CREATE TABLE users (
	user_id INT,
	fname   TEXT,
	lname   TEXT,
	
	PRIMARY KEY (user_id)
);

CREATE TABLE questions (
	question_id INT,
	title       TEXT,
	body        TEXT,
	
	PRIMARY KEY (question_id)
);

CREATE TABLE question_followers (
	follow_id   INT,
	user_id     INT,
	question_id INT,
	
	PRIMARY KEY (follow_id),
	FOREIGN KEY (user_id)     REFERENCES users(user_id),
	FOREIGN KEY (question_id) REFERENCES questions(question_id)
);


CREATE TABLE replies (
	reply_id    INT,
	parent      INT,   /* parent reply, may be null */
	user_id     INT,   /* user that made this reply */
	question_id INT,   /* question this is a reply to */
	body        TEXT,  /* body of the reply */
	PRIMARY KEY (reply_id),
	FOREIGN KEY (parent)      REFERENCES replies(reply_id),
	FOREIGN KEY (user_id)     REFERENCES users(user_id),
	FOREIGN KEY (question_id) REFERENCES questions(question_id)
);

CREATE TABLE question_likes (
	user_id     INT,
	question_id INT,
	FOREIGN KEY (user_id)     REFERENCES users(user_id),
	FOREIGN KEY (question_id) REFERENCES questions(question_id)
);

/* seed the db */
INSERT INTO users VALUES
	( 1, 'A', '1'),
	( 2, 'B', '2'),
	( 3, 'C', '3')
	;

INSERT INTO questions VALUES
	( 1, 'question 1', 'question body 1'),
	( 2, 'question 2', 'question body 2'),
	( 3, 'question 3', 'question body 3')
	;

INSERT INTO question_followers VALUES
	( 1, 1, 2), /* user 1 follows question 2 */
	( 2, 2, 3)  /* user 2 follows question 3 */
	;

INSERT INTO replies VALUES
	( 1, NULL, 1, 2, 'user 1 reply to question 2'),
	( 2, 1,    2, 2, 'user 2 reply to user 1 reply to question 2')
	;

INSERT INTO question_likes VALUES
	( 1, 2)  /* user 1 likes question 2 */
	;

