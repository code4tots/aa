CREATE TABLE users (
	user_id INT,
	fname   TEXT,
	lname   TEXT,
	
	PRIMARY KEY (user_id)
);

CREATE TABLE questions (
	question_id INT,
	user_id     INT,
	title       TEXT,
	body        TEXT,
	
	PRIMARY KEY (question_id),
	FOREIGN KEY (user_id)     REFERENCES users(user_id)
);

CREATE TABLE question_followers (
	question_follower_id   INT,
	user_id                INT,
	question_id            INT,
	
	PRIMARY KEY (question_follower_id),
	FOREIGN KEY (user_id)     REFERENCES users(user_id),
	FOREIGN KEY (question_id) REFERENCES questions(question_id)
);


CREATE TABLE replies (
	reply_id    INT,
	parent_id   INT,   /* parent reply, may be null */
	user_id     INT,   /* user that made this reply */
	question_id INT,   /* question this is a reply to */
	body        TEXT,  /* body of the reply */
	PRIMARY KEY (reply_id),
	FOREIGN KEY (parent_id)   REFERENCES replies(reply_id),
	FOREIGN KEY (user_id)     REFERENCES users(user_id),
	FOREIGN KEY (question_id) REFERENCES questions(question_id)
);

CREATE TABLE question_likes (
	question_like_id INT,
	user_id     INT,
	question_id INT,
	PRIMARY KEY (question_like_id),
	FOREIGN KEY (user_id)     REFERENCES users(user_id),
	FOREIGN KEY (question_id) REFERENCES questions(question_id)
);

/* seed the db */
INSERT INTO users VALUES
	( 1, 'A', '1'),
	( 2, 'B', '2'),
	( 3, 'C', '3'),
	( 4, 'D', '4')
	;

INSERT INTO questions VALUES
	( 1, 1, 'question 1', 'question body 1'), /* question 1 asked by user 1 */
	( 2, 2, 'question 2', 'question body 2'), /* question 2 asked by user 2 */
	( 3, 3, 'question 3', 'question body 3'), /* question 3 asked by user 3 */
	( 4, 1, 'question 4', 'question body 4'), /* question 4 asked by user 1 */
	( 5, 3, 'question 5', 'question body 5'), /* question 5 asked by user 3 */
	( 6, 3, 'question 6', 'question body 6')  /* question 6 asked by user 3 */
	;

INSERT INTO question_followers VALUES
	( 1, 1, 2), /* user 1 follows question 2 */
	( 2, 2, 3), /* user 2 follows question 3 */
	( 3, 1, 1)  /* user 1 follows quesiton 1 */
	;

INSERT INTO replies VALUES
	( 1, NULL, 1, 2, 'user 1 reply to question 2'),
	( 2, 1,    2, 2, 'user 2 reply to user 1 reply to question 2'),
	( 3, NULL, 3, 1, 'user 3 reply to question 1')
	;

INSERT INTO question_likes VALUES
	( 1, 1, 2), /* user 1 likes question 2 */
	( 2, 1, 1), /* user 1 likes quesiton 1 */
	( 3, 2, 1), /* user 2 likes question 1 */
	( 4, 1, 3)  /* user 1 likes question 3 */
	;

