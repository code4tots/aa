class CatRentalRequest < ActiveRecord::Base
  [:cat_id, :start_date, :end_date].each do |attribute|
    validates attribute, presence: true
  end
  
  validates :status, inclusion: { in: %w(APPROVED PENDING DENIED) }
  
  validate :does_not_overlap_approved_request
  
  belongs_to(:cat,
    foreign_key: :cat_id,
    class_name: :Cat)
  
  after_initialize do |cat_rental_request|
    cat_rental_request.status ||= 'PENDING'
  end
  
  def approve!
    ActiveRecord::Base.transaction do
      overlapping_requests.update_all(status: 'DENIED')
      update!(status: 'APPROVED')
    end
  end
  
  def deny!
    update!(status: 'DENIED')
    save!
    p ['LOOK HERE', self]
  end
  
  private
  
  def does_not_overlap_approved_request
    return if status == 'DENIED'
    
    unless overlapping_approved_requests.empty?
      errors[:base] << 'overlapping APPROVED requests found'
    end
  end
  
  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end
  
  def overlapping_requests
    requests = CatRentalRequest.where(<<-SQL, start_date, end_date, cat_id)
    /* date ranges overlap when you can prove they aren't disjoint */
    NOT (
      /* Case 1: self begins after this date range ends */
      (end_date < ?)  
      OR
      /* Case 2: self ends before this date range begins */
      (? < start_date))
    
    AND (cat_id = ?)
    SQL
    
    if id.nil?
      requests
    else
      requests.where('id <> ?', id)
    end
  end
end
