class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true, inclusion: %w(PENDING APPROVED DENIED)
  
  validate :approved_requests_do_not_overlap
  
  after_initialize do |cat_rental_request|
    cat_rental_request.status ||= "PENDING"
  end
  
  belongs_to :cat
  
  def approved_requests_do_not_overlap
    return if status == "DENIED"
    
    errors[:base] << 'overlaps with an approved request' unless
      overlapping_approved_requests.empty?
  end
  
  def approve!
    ActiveRecord::Base.transaction do
      update!(status: "APPROVED")
      overlapping_requests.update_all(status: "DENIED")
    end
  end
  
  def deny!
    update!(status: "DENIED")
  end
  
  private
  
  def overlapping_requests
    CatRentalRequest.where.not(id: id).where(<<-SQL, start_date, end_date)
    NOT (end_date < ? OR ? < start_date)
    SQL
  end
  
  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end
end
