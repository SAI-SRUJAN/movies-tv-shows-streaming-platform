-- Creating a database or schema with name nutflux_db
CREATE DATABASE nutflux_db;

-- To use the nutflux_db to create tables and store data
USE nutflux_db;

/*The movies_shows table is used to store all the various movies/tv shows that are available in the database.*/
CREATE TABLE movies_shows(nsan VARCHAR(10) PRIMARY KEY, title VARCHAR(255) NOT NULL,
 release_year YEAR NOT NULL, type VARCHAR(10) NOT NULL);
 
 /* movies_shows_info table is created to store the information of all the movies and TV shows with box office gross, language, synopsis,
  the plot_type giving more information about the plot of the movie/tv show, production company and runtime.*/
CREATE TABLE movies_shows_info(nsan VARCHAR(10) PRIMARY KEY, bo_gross INT, language VARCHAR(30), synopsis VARCHAR(1000), runtime SMALLINT, production_company VARCHAR(100), plot_type VARCHAR(250) DEFAULT 'Original',
 foreign key(nsan) references movies_shows(nsan) ON DELETE CASCADE);
 
 /* genre table is created to store the different genres available. 
The genre_name column has unique constraint so that the same genre cannot be added more than once.*/ 
CREATE TABLE genre(genre_id VARCHAR(5) PRIMARY KEY, genre_name VARCHAR(50) unique NOT NULL);

/* genre_map table is created to map and store the information of all the movies or TV shows and the genres associated with that movie or TV show.
nsan, genre_id is a whole primary key as a movie or TV show can have multiple genres and one genre can
be associated to a particular movie or TV show only once and this would avoid duplicate entries for same movie or TV show with same genre.*/
CREATE TABLE genre_map(nsan VARCHAR(10), genre_id VARCHAR(5),
PRIMARY KEY(nsan, genre_id),
foreign key(nsan) references movies_shows(nsan) ON DELETE CASCADE,
foreign key(genre_id) references genre(genre_id) ON DELETE CASCADE);

/* popular_quotes table is created to map and store the information of all the movies or TV shows and the associated popular quote with that movie or TV shows.*/
CREATE TABLE popular_quotes(nsan VARCHAR(10) PRIMARY KEY, quote VARCHAR(1000) NOT NULL,
foreign key(nsan) references movies_shows(nsan) ON DELETE CASCADE);

/* person_info table is created to store the name, nationality and gender of the various people.*/ 
CREATE TABLE person_info(person_id VARCHAR(10) PRIMARY KEY, name VARCHAR(100) NOT NULL, nationality VARCHAR(100) NOT NULL,
gender VARCHAR(6));

/* person_big_hit table is created to store the big hits of the various people in their career.*/ 
CREATE TABLE person_big_hit(person_id VARCHAR(10) , big_hit VARCHAR(250), 
PRIMARY KEY(person_id, big_hit),
foreign key(person_id) references person_info(person_id) ON DELETE CASCADE);

/* role_info table is used to store the various roles information that an actor/actress have portrayed*/
CREATE TABLE role_info(role_id VARCHAR(5) PRIMARY KEY, role VARCHAR(250) NOT NULL);

/* role_category table is used to store information about the various categories that can be there for a role. */
CREATE TABLE role_category(category_id VARCHAR(5) PRIMARY KEY, category VARCHAR(250) unique NOT NULL);

/* role_map table is used to map the various categories each role belongs to. role_id, category_id together is a primary key as a role can 
have multiple categories and a category can be mapped to a role only once.*/
CREATE TABLE role_map(role_id VARCHAR(5), category_id VARCHAR(5),
PRIMARY KEY(role_id, category_id),
foreign key(category_id) references role_category(category_id) ON DELETE CASCADE,
foreign key(role_id) references role_info(role_id) ON DELETE CASCADE);

/* cast_map table is created to map and store the information of all the movies and the actors/actresses associated with that movie. 
nsan, person_id, role_id is a combined primary key as a movie can have multiple people acting in it and one actor/actress can
be associated to a particular movie(single or multiple roles) and this would avoid duplicate entries for same movie with same actor/actress
for the same role.
role_type is used to store information about the type of the role(Ex: Male lead, Female lead, guest, etc)
role_priority determines which role is the main in the cast and if any guest role is important this can be used to display in that order.*/ 
CREATE TABLE cast_map(nsan VARCHAR(10), person_id VARCHAR(10), role_id VARCHAR(5), role_type VARCHAR(200)  NOT NULL, 
role_priority SMALLINT NOT NULL, 
PRIMARY KEY(nsan, person_id, role_id),
foreign key(nsan) references movies_shows(nsan) ON DELETE CASCADE,
foreign key(person_id) references person_info(person_id) ON DELETE CASCADE,
foreign key(role_id) references role_info(role_id) ON DELETE CASCADE);

/* crew_map table is created to map and store the information of all the movies and the crew members associated with that movie. 
nsan, person_id, crew_role is a combined primary key as a movie can have multiple people working in it and one person can
be associated to a particular movie for various roles(writer/director) and this would avoid duplicate entries for same movie with same person
for the same role.
crew_role is used to store information about the category of the role(Ex: director, writer, assistant-director, etc.)
crew_type determines which role is the main in the crew or if any guest role in that movie.*/ 
CREATE TABLE crew_map(nsan VARCHAR(10), person_id VARCHAR(10), crew_role VARCHAR(250) NOT NULL,
crew_type VARCHAR(5), 
PRIMARY KEY(nsan, person_id, crew_role),
foreign key(nsan) references movies_shows(nsan) ON DELETE CASCADE,
foreign key(person_id) references person_info(person_id) ON DELETE CASCADE);

/* To create the connections table and associate the various stars that are socially related together.
actor1_id, actor2_id, relationship is a composite primary key as we can add various relationships like dating, marriage or divorce between the same 
two actors more than once but the relationship in each case must be different.*/
CREATE TABLE connections(actor1_id VARCHAR(10) NOT NULL, actor2_id VARCHAR(10) NOT NULL, relationship VARCHAR(255) NOT NULL, relationship_year YEAR,
primary key(actor1_id, actor2_id, relationship),
foreign key(actor1_id) references person_info(person_id) ON DELETE CASCADE,
foreign key(actor2_id) references person_info(person_id) ON DELETE CASCADE);

/*Awards table is created to store the information of the various awards*/
CREATE TABLE awards(award_id VARCHAR(3) PRIMARY KEY, award_type VARCHAR(200) UNIQUE NOT NULL);

/* awards_map table is used to map the information of the award and the movie/tv show which was nominated for the award .*/
CREATE TABLE awards_map(awards_map_id INT PRIMARY KEY auto_increment, award_id VARCHAR(3), nsan VARCHAR(10), award_description VARCHAR(250) NOT NULL,
UNIQUE(award_id, nsan, award_description),
foreign key(nsan) references movies_shows(nsan) ON DELETE CASCADE,
foreign key(award_id) references awards(award_id) ON DELETE CASCADE);

/* awards_info table is used to map the information of the award and state whether the award was won or not and also the year of the awards.*/
CREATE TABLE awards_info(awards_map_id INT, award_won CHAR(3) NOT NULL,award_year YEAR,
PRIMARY KEY(awards_map_id, award_year),
foreign key(awards_map_id) references awards_map(awards_map_id) ON DELETE CASCADE);

/* award_person_map table is used to store information about the person who was nominated or won the award for that 
movie/tv show. As, there can be awards given only to the movies as a whole
and not to the individual person, so we maintain these details in a separate table.*/
CREATE TABLE award_person_map(awards_map_id INT, person_id VARCHAR(10), award_year YEAR,
PRIMARY KEY(awards_map_id, person_id, award_year),
foreign key(person_id) references person_info(person_id) ON DELETE CASCADE,
foreign key(awards_map_id, award_year) references awards_info(awards_map_id, award_year) ON DELETE CASCADE);

/*user_info table is created to store the information of the various users of the nutflux database.
user_type defines whether the user is standard or the power user*/
CREATE TABLE user_info(user_id VARCHAR(8) PRIMARY KEY, user_name VARCHAR(100),
user_gender VARCHAR(6), user_type VARCHAR(10) NOT NULL);

/* ratings table consists of the ratings given by the user for each movie/tv show.
user_id, nsan together is a primary key as one user can give a rating to a particular movie only once and
a particular user can give ratings to multiple movies.*/
CREATE TABLE ratings(user_id VARCHAR(8), nsan VARCHAR(10), rating TINYINT NOT NULL,
PRIMARY KEY(user_id, nsan),
foreign key(user_id) references user_info(user_id) ON DELETE CASCADE,
foreign key(nsan) references movies_shows(nsan) ON DELETE CASCADE); 



-- TRIGGERS
DROP TRIGGER IF EXISTS movie_show_check;

delimiter $$
create trigger movie_show_check before insert on movies_shows
for each row
begin
    if (new.type not in ('TV', 'Movie')) then
	signal sqlstate '42000'
	set message_text = 'Invalid type of data. Please enter Movie or TV';
	end if;
    if (new.nsan not like('nsan%')) then
	signal sqlstate '42000'
	set message_text = 'NSAN column should have values starting with nsan';
	end if;
end$$
delimiter ;


DROP TRIGGER IF EXISTS movie_show_runtime;
delimiter $$
create trigger movie_show_runtime before insert on movies_shows_info
for each row
begin
	if (new.runtime < 20 OR new.runtime > 250) then
	signal sqlstate '42000'
	set message_text = 'Enter a valid runtime';
	end if;
	if new.nsan not in (SELECT nsan from movies_shows) then
	signal sqlstate '42000'
	set message_text = 'Invalid Data Entered. Movie or TV show doesnt exist';
	end if;
end$$
delimiter ;


DROP TRIGGER IF EXISTS gender_check;
delimiter $$
create trigger gender_check before insert on person_info
for each row
begin
	if new.gender not in('Male', 'Female') then
	signal sqlstate '42000'
	set message_text = 'Cannot add row. Invalid gender entered.';
	end if;
end$$
delimiter ;


DROP TRIGGER IF EXISTS ratings_check;
delimiter $$
create trigger ratings_check before insert on ratings
for each row
begin
	if (new.rating < 1) OR (new.rating > 10) then
	signal sqlstate '45000'
	set message_text = 'Ratings for the movie should be between 1-10';
	end if;
	if new.nsan not in (SELECT nsan from movies_shows) then
	signal sqlstate '42000'
	set message_text = 'Invalid Data Entered. Movie or TV show doesnt exist';
	end if;
	if new.user_id not in (SELECT user_id from user_info) then
	signal sqlstate '42000'
	set message_text = 'Invalid Data Entered. User doesnt exist';
	end if;
end$$
delimiter ;


DROP TRIGGER IF EXISTS user_info_check;
delimiter $$
create trigger user_info_check before insert on user_info
for each row
begin
	if (new.user_gender not in ('Male', 'Female') OR (new.user_type not in ('Standard','Power'))) then
	signal sqlstate '45000'
	set message_text = 'Cannot add row: Invalid data entered';
	end if;
end$$
delimiter ;





-- Insert statements to add data into the tables
INSERT INTO movies_shows(nsan, title, release_year, type) VALUES ('nsan00001', 'Iron Man', 2008, 'Movie'),
('nsan00002', 'Iron Man 2', 2010, 'Movie'), 
('nsan00003', 'Iron Man 3', 2013, 'Movie'),
('nsan00004', 'Belfast', 2021, 'Movie'),
('nsan00005','Dune', 2021, 'Movie'),
('nsan00006','Dune', 1984, 'Movie'),
('nsan00007','Green Lantern', 2011, 'Movie'),
('nsan00008', 'The Fresh Prince of Bel-Air', 1990, 'TV'),
('nsan00009', 'Men in Black', 1997, 'Movie'),
('nsan00010', 'Mr. & Mrs. Smith', 2005, 'Movie'),
('nsan00011', 'By the Sea', 2015, 'Movie'),
('nsan00012', 'Friends', 1994, 'TV'),
('nsan00013', 'Sherlock Holmes', 2009, 'Movie'),
('nsan00014', 'Se7en', 1995, 'Movie'),
('nsan00015', 'Just Go with It', 2011, 'Movie'),
('nsan00016', 'Big Little Lies', 2017, 'TV'),
('nsan00017', 'Eyes Wide Shut', 1999, 'Movie'),
('nsan00018', 'That \'70s Show', 1998, 'TV'),
('nsan00019', 'The Big Bang Theory', 2007, 'TV'),
('nsan00020', 'The Vampire Diaries', 2009, 'TV'),
('nsan00021', 'Parasite', 2019, 'Movie'),
('nsan00022', 'Nocturnal Animals', 2016, 'Movie'),
('nsan00023', 'The Last Command', 1928, 'Movie');


INSERT INTO movies_shows_info(nsan, bo_gross, language, synopsis, runtime, production_company, plot_type) VALUES 
('nsan00001', 585800000, 'English', 'After being held captive in an Afghan cave, billionaire engineer Tony Stark creates a unique weaponized suit of armor to fight evil.',
126, 'Marvel Studios', DEFAULT),
('nsan00002', 623900000, 'English', 'With the world now aware of his identity as Iron Man, Tony Stark must contend with both his declining health and a vengeful mad man with ties to his father\'s legacy.',
124, 'Marvel Studios', 'Sequel to Iron Man'),
('nsan00003', 1214000000, 'English', 'When Tony Stark\'s world is torn apart by a formidable terrorist called the Mandarin, he starts an odyssey of rebuilding and retribution.',
130, 'Marvel Studios', 'Sequel to Iron Man 3'),
('nsan00004',45000000, 'English', 'A young boy and his working-class Belfast family experience the tumultuous late 1960s.',
98, 'TKBC', DEFAULT),
('nsan00005', 398300000, 'English', 'A noble family becomes embroiled in a war for control over the galaxy\'s most valuable asset while its heir becomes troubled by visions of a dark future.',
155, 'Warner Bros', 'Dune was adapted from the 1965 novel by Frank Herbert'),
('nsan00006', 27503491, 'English', 'A noble family becomes embroiled in a war for control over the galaxy\'s most valuable asset while its heir becomes troubled by visions of a dark future.',
137, 'Dino De Laurentiis Company', 'Dune was adapted from the 1965 novel by Frank Herbert'),
('nsan00007', 219900000, 'English', 'Reckless test pilot Hal Jordan is granted an alien ring that bestows him with otherworldly powers that inducts him into an intergalactic police force, the Green Lantern Corps.',
114, 'Warner Bros.', DEFAULT),
('nsan00008', 3300000, 'English', 'A streetwise, poor young man from Philadelphia is sent by his mother to live with his aunt, uncle and cousins in their Bel-Air mansion.',
22, 'Quincy Jones Entertainment', DEFAULT),
('nsan00009', 589400000, 'English', 'A police officer joins a secret organization that polices and monitors extraterrestrial interactions on Earth.',
98, 'Columbia Pictures', DEFAULT),
('nsan00010',  487300000, 'English', 'A bored married couple is surprised to learn that they are both assassins hired by competing agencies to kill each other.',
120, 'New Regency Productions', DEFAULT),
('nsan00011',  3300000, 'English', 'A couple tries to repair their marriage while staying at a hotel in France.',
122, 'Universal Pictures', DEFAULT),
('nsan00012',  246168, 'English', 'Follows the personal and professional lives of six twenty to thirty-something-year-old friends living in Manhattan.',
22, 'Bright/Kauffman/Crane Productions', DEFAULT),
('nsan00013',  524000000, 'English', 'Detective Sherlock Holmes and his stalwart partner Watson engage in a battle of wits and brawn with a nemesis whose plot is a threat to all of England.',
128, 'Warner Bros.', DEFAULT),
('nsan00014',  327300000, 'English', 'Two detectives, a rookie and a veteran, hunt a serial killer who uses the seven deadly sins as his motives.',
127, 'Cecchi Gori Pictures', DEFAULT),
('nsan00015',  215000000, 'English', 'On a weekend trip to Hawaii, a plastic surgeon convinces his loyal assistant to pose as his soon-to-be-divorced wife in order to cover up a careless lie he told to his much-younger girlfriend.',
117, 'Columbia Pictures', DEFAULT),
('nsan00016',  280000000, 'English', 'The apparently perfect lives of upper-class mothers, at a prestigious elementary school, unravel to the point of murder when a single mother moves to their quaint Californian beach town.',
60, 'Home Box Office (HBO)', DEFAULT),
('nsan00017',  162100000, 'English', 'A Manhattan doctor embarks on a bizarre, night-long odyssey after his wife\'s admission of unfulfilled longing.',
159, 'Warner Bros.', DEFAULT),
('nsan00018',  350000000, 'English', 'A comedy revolving around a group of teenage friends, their mishaps, and their coming of age, set in 1970s Wisconsin.',
22, 'Carsey-Werner-Mandabach Productions', DEFAULT),
('nsan00019',  585000000, 'English', 'A woman who moves into an apartment across the hall from two brilliant but socially awkward physicists shows them how little they know about life outside of the laboratory.',
22, 'Warner Bros. Television', DEFAULT),
('nsan00020',  155000000, 'English', 'The lives, loves, dangers and disasters in the town, Mystic Falls, Virginia. Creatures of unspeakable horror lurk beneath this town as a teenage girl is suddenly torn between two vampire brothers.',
43, 'Outerbanks Entertainment', DEFAULT),
('nsan00021',  263000000, 'English', 'Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.',
132, 'CJ Entertainment', DEFAULT),
('nsan00022',  32000000, 'English', 'A wealthy art gallery owner is haunted by her ex-husband\'s novel, a violent thriller she interprets as a symbolic revenge tale.',
116, 'Focus Features', DEFAULT),
('nsan00023',  300000, 'English', 'A former Imperial Russian general and cousin of the Czar ends up in Hollywood as an extra in a movie directed by a former revolutionary.',
88, 'Paramount Pictures', DEFAULT);

INSERT INTO genre(genre_id, genre_name) VALUES ('AN', 'Action'),
('WR', 'War'),
('SF', 'Science Fiction'),
('AE', 'Adventure'),
('TR', 'Thriller'),
('CY', 'Comedy'),
('DA', 'Drama'),
('DY', 'Dramedy'),
('FY', 'Fantasy'),
('RE', 'Romance'),
('DC', 'Dark Comedy'),
('RC', 'Romantic Comedy'),
('CE', 'Crime'),
('SM', 'Sitcom'),
('NF', 'Noir Fiction'),
('DN', 'Detective Novel'),
('MY', 'Mystery'),
('IE', 'Indie'),
('HR', 'Horror'),
('SE', 'Suspense'),
('PF', 'Psychological Fiction');

INSERT INTO genre_map(nsan, genre_id) VALUES ('nsan00001', 'AN'), ('nsan00001', 'WR'), ('nsan00001', 'SF'), ('nsan00001', 'AE'),
('nsan00001', 'TR'), ('nsan00002', 'AN'), ('nsan00002', 'SF'), ('nsan00002', 'AE'), ('nsan00003', 'AN'), ('nsan00003', 'SF'), ('nsan00003', 'AE'),
('nsan00003', 'CY'),
('nsan00004', 'DA'), ('nsan00004', 'DY'),
('nsan00005', 'AN'), ('nsan00005', 'SF'), ('nsan00005', 'AE'), ('nsan00005', 'FY'),
('nsan00005', 'DA'),
('nsan00006', 'AN'), ('nsan00006', 'SF'), ('nsan00006', 'AE'), ('nsan00006', 'FY'),
('nsan00006', 'DA'),
('nsan00007', 'AN'), ('nsan00007', 'SF'), ('nsan00007', 'AE'), ('nsan00007', 'FY'),
('nsan00007', 'TR'),
('nsan00008', 'CY'), ('nsan00009', 'CY'), ('nsan00009', 'SF'), ('nsan00009', 'AN'),
('nsan00010', 'AN'), ('nsan00010', 'AE'), ('nsan00010', 'RE'), ('nsan00010', 'DC'), 
('nsan00010', 'CY'), ('nsan00010', 'TR'), ('nsan00010', 'RC'), ('nsan00010', 'CE'),
('nsan00011', 'DA'), ('nsan00011', 'RE'),
('nsan00012', 'SM'), ('nsan00012', 'CY'), ('nsan00012', 'RE'),
('nsan00013', 'CE'), ('nsan00013', 'NF'), ('nsan00013', 'DN'), ('nsan00013', 'AE'), ('nsan00013', 'MY'),
('nsan00014', 'TR'), ('nsan00014', 'PF'),
('nsan00015', 'CY'), ('nsan00015', 'RC'), ('nsan00015', 'RE'),
('nsan00016', 'DA'), ('nsan00016', 'MY'), ('nsan00016', 'DC'),
('nsan00017', 'TR'), ('nsan00017', 'DA'), ('nsan00017', 'MY'),
('nsan00018', 'SM'), ('nsan00018', 'RE'), ('nsan00018', 'CY'),
('nsan00019', 'SM'), ('nsan00019', 'CY'),
('nsan00020', 'HR'), ('nsan00020', 'RE'), ('nsan00020', 'SE'), ('nsan00020', 'DA'),
('nsan00021', 'TR'), ('nsan00021', 'CY'), ('nsan00021', 'DA'), ('nsan00021', 'PF'),
('nsan00022', 'TR'), ('nsan00022', 'PF');

INSERT INTO popular_quotes(nsan, quote) VALUES ('nsan00001', 'I am Iron Man.'),
('nsan00002', 'You have a bug gun, that doesn\'t mean you are the big gun!'),
('nsan00003', 'Jarvis, do me a favor, blow the Mark 42.'),
('nsan00004', 'Too long a scarifice can make a stone of heart'),
('nsan00005', 'Fear is the mind-killer. Fear is the little-death that brings total obliteration. I will face my fear. I will permit it to pass over me and through me.'),
('nsan00006', 'Fear is the mind-killer. Fear is the little-death that brings total obliteration. I will face my fear. I will permit it to pass over me and through me.'),
('nsan00007', 'In brightest day, in blackest night, no evil shall escape my sight! Let those who worship evil\'s might, beware my power. Green Lantern\'s light!'),
('nsan00008', 'Quite Right Sir. You Threw Him On The Lawn, He ROLLED Into The Street.'),
('nsan00009', 'You know what the difference is between you and me? I make this look GOOD.'),
('nsan00012', 'We were on a break!');

INSERT INTO person_info(person_id, name, nationality, gender) VALUES ('PER0001', 'Robert Downey Jr.', 'American', 'Male'),
 ('PER0002', 'Jon Favreau', 'American', 'Male'), ('PER0003', 'Gwyneth Paltrow', 'American', 'Female'),
('PER0004', 'Stan Lee', 'American', 'Male'),
('PER0005', 'Jude Hill', 'Irish', 'Male'),
('PER0006', 'Lewis McAskie', 'Irish', 'Male'),
('PER0007', 'Judi Dench', 'British', 'Female'),
('PER0008', 'Kenneth Branagh', 'Irish', 'Male'),
('PER0009', 'Jason Momoa', 'American', 'Male'),
('PER0010', 'Zendaya', 'American','Female'), 
('PER0011', 'Denis Villeneuve', 'Canadian', 'Male'),
('PER0012', 'Joe Walker', 'British', 'Male'),
('PER0013', 'Richard Jordan', 'American', 'Male'),
('PER0014', 'Sean Young', 'American','Female'), 
('PER0015', 'Antony Gibbs', 'British', 'Male'),
('PER0016', 'David Lynch', 'American', 'Male'),
('PER0017', 'Ryan Reynolds', 'Canadian', 'Male'),
('PER0018', 'Blake Lively', 'American','Female'), 
('PER0019', 'Martin Campbell', 'New Zealand', 'Male'),
('PER0020', 'Dion Beebe', 'Australian', 'Male'),
('PER0021', 'Will Smith', 'American', 'Male'),
('PER0022', 'Shelley Jensen', 'American', 'Male'), 
('PER0023', 'Jeff Melman', 'American', 'Male'),
('PER0024', 'Alfonso Ribeiro', 'American', 'Male'),
('PER0025', 'Tommy Lee Jones', 'American', 'Male'),
('PER0026', 'Barry Sonnenfeld', 'American', 'Male'),
('PER0027', 'Brad Pitt', 'American', 'Male'),
('PER0028', 'Angelina Jolie', 'American', 'Female'),
('PER0029', 'Doug Liman', 'American', 'Male'),
('PER0030', 'Jennifer Aniston', 'American', 'Female'),
('PER0031', 'Courteney Cox', 'American', 'Female'),
('PER0032', 'Lisa Kudrow', 'American', 'Female'),
('PER0033', 'Matt LeBlanc', 'American', 'Male'),
('PER0034', 'Matthew Perry', 'Canadian', 'Male'),
('PER0035', 'David Schwimmer', 'American', 'Male'),
('PER0036', 'Gary Halvorson', 'American', 'Male'),
('PER0037', 'Guy Ritchie', 'British', 'Male'),
('PER0038', 'Rachel McAdams', 'Cabadian', 'Female'),
('PER0039', 'David Fincher', 'American', 'Male'),
('PER0040', 'Adam Sandler', 'American', 'Male'),
('PER0041', 'Dennis Dugan', 'American', 'Male'),
('PER0042', 'Nicole Kidman', 'Australian', 'Female'),
('PER0043', 'Reese Witherspoon', 'American', 'Female'),
('PER0044', 'Tom Cruise', 'American', 'Male'),
('PER0045', 'Stanley Kubrick', 'American', 'Male'),
('PER0046', 'Ashton Kutcher', 'American', 'Male'),
('PER0047', 'Mila Kunis', 'American', 'Female'),
('PER0048', 'David Trainer', 'American', 'Male'),
('PER0049', 'Johnny Galecki', 'American', 'Male'),
('PER0050', 'Jim Parsons', 'American', 'Male'),
('PER0051', 'Kaley Cuoco', 'American', 'Female'),
('PER0052', 'Mark Cendrowski', 'American', 'Male'),
('PER0053', 'Ian Somerhalder', 'American', 'Male'),
('PER0054', 'Nina Dobrev', 'Canadian', 'Female'),
('PER0055', 'Chris Grismer', 'Canadian', 'Male'),
('PER0056', 'Kang-ho Song', 'South Korean', 'Male'),
('PER0057', 'Bong Joon Ho', 'South Korean', 'Male'),
('PER0058', 'Amy Adams', 'American', 'Female'),
('PER0059', 'Tom Ford', 'American', 'Male'),
('PER0060', 'Emil Jannings', 'Austrian', 'Male'),
('PER0061', 'Josef von Sternberg', 'Austrian', 'Male');

INSERT INTO person_big_hit(person_id, big_hit) VALUES ('PER0001', 'Avengers: Endgame'), 
('PER0002', 'The Jungle Book'), 
('PER0003', 'The Royal Tenenbaums'),
('PER0004', 'Marvel Comics'),
('PER0005', 'Belfast'),
('PER0006', 'Belfast'),
('PER0007', 'James Bond series'),
('PER0008', 'Hamlet'),
('PER0009', 'Aquaman'),
('PER0010', 'Euphoria'), 
('PER0011', 'Blade Runner 2049'),
('PER0012', 'Sicario'),
('PER0013', 'The Friends of Eddie Coyle'),
('PER0014', 'Blade Runner 2049'), 
('PER0015', 'Tom Jones'),
('PER0016', 'Dune'),
('PER0017', 'Deadpool'),
('PER0018', 'The Age of Adaline'),
('PER0019', 'Casino Royale'),
('PER0020', 'Equilibrium'),
('PER0021', 'Men In Black'),
('PER0022', 'Brothers'),
('PER0023', 'Modern Family'),
('PER0024', 'Silver Spoons'),
('PER0025', 'The Fugitive'),
('PER0026', 'Men in Black'),
('PER0027', '12 Years a Slave'),
('PER0028', 'Lara Croft: Tomb Raider'),
('PER0029', 'Swingers'),
('PER0030', 'We\'re the Millers'),
('PER0031', 'Scream'),
('PER0032', 'Leslie'),
('PER0033', 'Friends'),
('PER0034', 'Friends'),
('PER0035', 'Friends'),
('PER0036', 'Friends'),
('PER0037', 'Snatch'),
('PER0038', 'Mean Girls'),
('PER0039', 'Gone Girl'),
('PER0040', 'Happy Gilmore'),
('PER0041', 'Grown Ups'),
('PER0042', 'Eyes Wide Shut'),
('PER0043', 'Legally Blonde'),
('PER0044', 'Mission Impossible'),
('PER0045', 'Dr. Strangelove'),
('PER0046', 'That \'70s Show'),
('PER0047', 'Family Guy'),
('PER0048', 'The Ranch'),
('PER0049', 'The Big Bang Theory'),
('PER0050', 'The Big Bang Theory'),
('PER0051', 'The Big Bang Theory'),
('PER0052', 'The Big Bang Theory'),
('PER0053', 'Lost'),
('PER0054', 'Degrassi: The Next Generation'),
('PER0055', 'Designated Survivor'),
('PER0056', 'Parasite'),
('PER0057', 'Parasite'),
('PER0059', 'A Single Man');

INSERT INTO role_info(role_id, role) VALUES ('TO-ST', 'Tony Stark'),('PE-PO', 'Pepper Potts'),
('BU-DY', 'Buddy'), ('WI-LL', 'Will'), ('GR-NY', 'Granny'),
('DU-ID', 'Duncan Idaho'),('CH-NI', 'Chani'),
('GR-LA', 'Green Lantern'), ('CA-FE', 'Carol Ferris'),
('WI-SM', 'Will Smith'), ('KA-AY', 'Kay'), ('JA-AY', 'Jay'),
('JO-SM', 'John Smith'), ('JA-SM', 'Jane Smith'),
('RO-ND', 'Roland'), ('VA-SA', 'Vanessa'),
('RA-GR', 'Rachel Green'), ('MO-GE', 'Monica Geller'),
('PH-BU', 'Phoebe Buffay'), ('JO-TR', 'Joey Tribbiani'), ('CH-BI', 'Chandler Bing'), ('RO-GE', ' Dr. Ross Geller'),
('SH-HO', 'Sherlock Holmes'), ('IR-AD', 'Irene Adler'),
('MI-LS', 'Mills'), ('TR-CY', 'Tracy'),
('DA-NY', 'Danny'), ('KA-NE', 'Katherine'),
('DE-AD', 'Devlin Adams'),
('CE-WR', 'Celeste Wright'), ('MA-MA', ' Madeline Martha Mackenzie'),
('WI-HA', 'Dr. William Harford'), ('AL-HA', 'Alice Harford'),
('MI-KE', 'Michael Kelso'), ('JA-BU', 'Jackie Burkhart'),
('LE-HO', 'Leonard Hofstadter'), ('SH-CO', 'Sheldon Cooper'),
('PE-NY', 'Penny'),
('DA-SA', 'Damon Salvatore'), ('EL-GI', 'Elena Gilbert'),
('KI-TA', 'Ki Taek'),
('SU-MO', 'Susan Morrow'),
('GA-DU', 'Grand Duke Sergius Alexander');

INSERT INTO role_category(category_id, category) VALUES ('SUP', 'Superhero'), ('CEO', 'CEO'),
('SWO', 'Sword Master'), ('HER', 'Hero'), ('PLA', 'Playboy'), ('PHI', 'Philantophist'),
('FIC', 'Fictional'), ('DET', 'Detective'), ('PRO', 'Protagonists'),
('SPY', 'Spy');

INSERT INTO role_map(role_id, category_id) VALUES ('TO-ST', 'SUP'),('TO-ST', 'PLA'), ('TO-ST', 'PHI'), ('TO-ST', 'HER'), ('PE-PO', 'CEO'),
('DU-ID', 'SWO'), ('BU-DY', 'HER'), ('WI-LL', 'HER'), ('DU-ID', 'HER'), ('GR-LA', 'HER'),
('GR-LA', 'SUP'), ('WI-SM', 'FIC'),
('KA-AY', 'DET'), ('KA-AY', 'FIC'), ('KA-AY', 'PRO'),
('JA-AY', 'DET'), ('JA-AY', 'FIC'), ('JA-AY', 'PRO'),
('JO-SM', 'SPY'), ('JO-SM', 'DET'),
('SH-HO', 'SPY'), ('SH-HO', 'DET'),
('MI-LS', 'SPY'), ('MI-LS', 'DET');

INSERT INTO cast_map(nsan, person_id, role_id, role_type, role_priority) VALUES 
('nsan00001', 'PER0001', 'TO-ST', 'Male Lead', 1), ('nsan00001', 'PER0003', 'PE-PO', 'Female Lead', 2), ('nsan00002', 'PER0001', 'TO-ST', 'Male Lead', 1), 
('nsan00002', 'PER0003', 'PE-PO', 'Female Lead', 2),
('nsan00003', 'PER0001', 'TO-ST', 'Male Lead', 1), ('nsan00003', 'PER0003', 'PE-PO', 'Female Lead', 2),
('nsan00004', 'PER0005', 'BU-DY', 'Male Lead', 2), ('nsan00004', 'PER0006', 'WI-LL', 'Male Lead', 3), ('nsan00004', 'PER0007', 'GR-NY', 'Support', 1),
('nsan00005', 'PER0009', 'DU-ID', 'Male Lead', 1), ('nsan00005', 'PER0010', 'CH-NI', 'Support', 2),
('nsan00006', 'PER0013', 'DU-ID', 'Male Lead', 1), ('nsan00006', 'PER0014', 'CH-NI', 'Support', 2),
('nsan00007', 'PER0017', 'GR-LA', 'Male Lead', 1), ('nsan00007', 'PER0018', 'CA-FE', 'Female Lead', 2),
('nsan00008', 'PER0021', 'WI-SM', 'Male Lead', 1), ('nsan00009', 'PER0021', 'JA-AY', 'Male Lead', 1), ('nsan00009', 'PER0025', 'KA-AY', 'Male Lead', 2),
('nsan00010', 'PER0027', 'JO-SM', 'Male Lead', 1), ('nsan00010', 'PER0028', 'JA-SM', 'Female Lead', 2),
('nsan00011', 'PER0027', 'RO-ND', 'Male Lead', 2), ('nsan00011', 'PER0028', 'VA-SA', 'Female Lead', 1),
('nsan00012', 'PER0030', 'RA-GR', 'Female Lead', 1), ('nsan00012', 'PER0031', 'MO-GE', 'Female Lead', 2), ('nsan00012', 'PER0032', 'PH-BU', 'Female Lead', 3),
('nsan00012', 'PER0033', 'JO-TR', 'Male Lead', 4), ('nsan00012', 'PER0034', 'CH-BI', 'Male Lead', 5), ('nsan00012', 'PER0035', 'RO-GE', 'Male Lead', 6),
('nsan00013', 'PER0001', 'SH-HO', 'Male Lead', 1), ('nsan00013', 'PER0038', 'IR-AD', 'Female Lead', 2),
('nsan00014', 'PER0027', 'MI-LS', 'Male Lead', 1), ('nsan00014', 'PER0003', 'TR-CY', 'Female Lead', 2),
('nsan00015', 'PER0040', 'DA-NY', 'Male Lead', 1), ('nsan00015', 'PER0030', 'KA-NE', 'Female Lead', 2),
('nsan00015', 'PER0042', 'DE-AD', 'Female Lead', 2),
('nsan00016', 'PER0042', 'CE-WR', 'Female Lead', 1), ('nsan00016', 'PER0043', 'MA-MA', 'Female Lead', 2),
('nsan00017', 'PER0044', 'WI-HA', 'Male Lead', 1), ('nsan00017', 'PER0042', 'AL-HA', 'Female Lead', 2),
('nsan00018', 'PER0046', 'MI-KE', 'Male Lead', 1), ('nsan00018', 'PER0047', 'JA-BU', 'Female Lead', 2),
('nsan00019', 'PER0049', 'LE-HO', 'Male Lead', 2), ('nsan00019', 'PER0050', 'SH-CO', 'Male Lead', 1), ('nsan00019', 'PER0051', 'PE-NY', 'Female Lead', 3),
('nsan00020', 'PER0053', 'DA-SA', 'Male Lead', 1), ('nsan00020', 'PER0054', 'EL-GI', 'Female Lead', 2),
('nsan00021', 'PER0056', 'KI-TA', 'Male Lead', 1),
('nsan00022', 'PER0058', 'SU-MO', 'Female Lead', 1),
('nsan00023', 'PER0060', 'GA-DU', 'Male Lead', 1);

INSERT INTO crew_map(nsan, person_id, crew_role, crew_type) VALUES ('nsan00001', 'PER0002', 'Director', 'Main'),
('nsan00002', 'PER0002', 'Director', 'Main'),
('nsan00002', 'PER0004', 'Writer', 'Main'), ('nsan00001', 'PER0004', 'Writer', 'Main'), ('nsan00003', 'PER0002', 'Director', 'Main'),
('nsan00003', 'PER0004', 'Writer', 'Main'),
('nsan00004', 'PER0008', 'Director', 'Main'),
('nsan00004', 'PER0008', 'Writer', 'Main'),
('nsan00005', 'PER0011', 'Director', 'Main'),
('nsan00005', 'PER0012', 'Editor', 'Main'),
('nsan00006', 'PER0016', 'Director', 'Main'),
('nsan00006', 'PER0015', 'Editor', 'Main'),
('nsan00007', 'PER0019', 'Director', 'Main'),
('nsan00007', 'PER0020', 'Director Of Photography', 'Main'),
('nsan00008', 'PER0022', 'Director', 'Main'),
('nsan00008', 'PER0023', 'Director', 'Main'),('nsan00008','PER0024' , 'Director', 'Guest'),
('nsan00009', 'PER0026', 'Director', 'Main'),
('nsan00010', 'PER0029', 'Director', 'Main'),
('nsan00011', 'PER0028', 'Director', 'Main'),
('nsan00011', 'PER0028', 'Writer', 'Main'),
('nsan00012', 'PER0036', 'Director', 'Main'),
('nsan00013', 'PER0037', 'Director', 'Main'),
('nsan00014', 'PER0039', 'Director', 'Main'),
('nsan00015', 'PER0041', 'Director', 'Main'),
('nsan00017', 'PER0045', 'Director', 'Main'),
('nsan00018', 'PER0048', 'Director', 'Main'),
('nsan00019', 'PER0052', 'Director', 'Main'),
('nsan00020', 'PER0055', 'Director', 'Main'),
('nsan00021', 'PER0057', 'Director', 'Main'),
('nsan00022', 'PER0059', 'Director', 'Main'),
('nsan00023', 'PER0061', 'Director', 'Main'); 


INSERT INTO awards(award_id, award_type) VALUES ('OSC', 'Oscar'),
('BAF', 'BAFTA'), ('AAC', 'AACTA'),
('BFC', 'Broadcast Film Critics Association Awards'),
('VFC', 'Vancouver Film Critics Circle'),
('SFC', 'Sunset Film Circle Awards'),
('ASC', 'ASCAP Film and Television Music Awards'),
('ACA', 'American Comedy Awards'),
('GGL', 'Golden Globes, USA'),
('IFT', 'Irish Film and Television Awards'),
('MTV', 'MTV Movie + TV Awards'),
('PEA', 'Primetime Emmy Awards');

INSERT INTO awards_map(award_id, nsan, award_description) VALUES ('OSC', 'nsan00004', 'Best Original Screenplay'),
('OSC', 'nsan00004', 'Best Motion Picture of the Year'),
('BAF', 'nsan00004', 'Outstanding British Film of the Year'),
('AAC', 'nsan00004', 'Best Supporting Actress'),
('BFC', 'nsan00004', 'Critics - Best Young Actor/Actress'),
('OSC', 'nsan00005', 'Best Sound'),
('OSC', 'nsan00005', 'Best Achievement in Film Editing'),
('VFC', 'nsan00005', 'Best Director'),
('SFC', 'nsan00005', 'Best Film'),
('ASC', 'nsan00008', 'Top TV Series'),
('ACA', 'nsan00012', 'Funniest Supporting Female Performer in a Television Series'),
('ASC', 'nsan00012', 'Top Television Series'),
('GGL', 'nsan00013', 'Best Performance by an Actor in a Motion Picture - Comedy or Musical'),
('IFT', 'nsan00013', 'Best International Actor'),
('MTV', 'nsan00013', 'Best Fight'),
('PEA', 'nsan00016', 'Outstanding Lead Actress in a Limited Series or Movie'),
('PEA', 'nsan00012', 'Outstanding Lead Actress in a Comedy Series'),
('OSC', 'nsan00023', 'Best actor award'); 


INSERT INTO awards_info(awards_map_id, award_won, award_year) VALUES (1, 'Yes', 2022),
(2, 'No', 2022), (3, 'Yes', 2022), (4, 'Yes', 2022), (5, 'Yes', 2022),
(6, 'Yes', 2022), (7, 'Yes', 2022), (8, 'Yes', 2022), (9, 'Yes', 2022), (10, 'Yes', 1994),
(11, 'Yes', 2000),
(12, 'Yes', 1995),
(12, 'Yes', 1996),
(12, 'Yes', 1997), (12, 'Yes', 1998), (12, 'Yes', 1999), (12, 'Yes', 2000),(12, 'Yes', 2001),
(13, 'Yes', 2010),
(14, 'Yes', 2010),
(15, 'No', 2010),
(16, 'Yes', 2017),
(17, 'Yes', 2002),
(18, 'Yes', 1928);

INSERT INTO award_person_map(awards_map_id, person_id, award_year) VALUES (4,'PER0007',2022), 
(5,'PER0005', 2022),
(7,'PER0012', 2022),
(8, 'PER0011', 2022),
(10,'PER0021', 1994),
(11,'PER0032', 2000),
(13,'PER0001',2010),
(14,'PER0001',2010),
(15,'PER0001',2010),
(16,'PER0042',2017),
(17, 'PER0030', 2002),
(18,'PER0060',1928);

INSERT into connections(actor1_id, actor2_id, relationship, relationship_year) VALUES 
('PER0017', 'PER0018', 'Marriage', 2012),
('PER0027', 'PER0028', 'Dating', 2005),
('PER0027', 'PER0028', 'Marriage', 2014),
('PER0027', 'PER0028', 'Divorced', 2019),
('PER0042', 'PER0044', 'Marriage', 1990),
('PER0042', 'PER0044', 'Divorced', 2001),
('PER0027', 'PER0030', 'Dating', 1994),
('PER0027', 'PER0030', 'Marriage', 2000),
('PER0027', 'PER0030', 'Divorced', 2005),
('PER0046', 'PER0047', 'Marriage', 2015),
('PER0046', 'PER0047', 'Dating', 2012),
('PER0049', 'PER0051', 'Dating', 2007),
('PER0053', 'PER0054', 'Dating', 2009);

INSERT INTO user_info(user_id, user_name, user_gender, user_type) VALUES ('USR1', 'Tim David', 'Male', 'Standard'),
('USR2', 'Tom', 'Male', 'Standard'),
('USR3', 'Luke', 'Male', 'Power'), ('USR4', 'Leia', 'Female', 'Power'),
('USR5', 'Cathy Hopper', 'Female', 'Standard'),
('USR6', 'Max Henry', 'Male', 'Standard'),
('USR7', 'Zara Haas', 'Male', 'Power'),
('USR8', 'Ellie', 'Female', 'Power'),
('USR9', 'Mario', 'Male', 'Power'),
('USR10', 'Luigi', 'Male', 'Standard');

INSERT INTO ratings(user_id, nsan, rating) VALUES ('USR1', 'nsan00001', 10),
('USR10', 'nsan00010', 8),
('USR2', 'nsan00001', 9),
('USR2', 'nsan00008', 3),
('USR2', 'nsan00007', 6),
('USR3', 'nsan00004', 9),
('USR3', 'nsan00005', 8),
('USR4', 'nsan00002', 10),
('USR4', 'nsan00006', 7),
('USR9', 'nsan00008', 4),
('USR9', 'nsan00005', 10),
('USR7', 'nsan00003', 10),
('USR6', 'nsan00009', 9),
('USR10', 'nsan00005', 10);


-- Views
CREATE OR REPLACE VIEW movies_shows_awards_view AS
SELECT title as Title, release_year as Year_Of_Release, award_type as Award, count(*) as No_Of_Awards,  type as Type from movies_shows 
JOIN awards_map
ON movies_shows.nsan = awards_map.nsan
JOIN awards
ON awards.award_id = awards_map.award_id
GROUP BY title, release_year, award_type
ORDER BY title, release_year;

SELECT * FROM movies_shows_awards_view;


CREATE OR REPLACE VIEW director_view AS
SELECT title as Title, release_year as Year_Of_Release, synopsis as Summary, name as Director, big_hit as Classic_Films  from movies_shows 
JOIN movies_shows_info
ON movies_shows.nsan = movies_shows_info.nsan
JOIN crew_map
ON movies_shows.nsan = crew_map.nsan
JOIN person_info
ON person_info.person_id = crew_map.person_id
JOIN person_big_hit
ON person_big_hit.person_id = person_info.person_id
WHERE crew_role = 'Director';

SELECT * from director_view;

CREATE OR REPLACE VIEW genre_view AS
SELECT title as Title, release_year as Year_Of_Release, genre_name as Genre, type as Type from movies_shows 
JOIN movies_shows_info
ON movies_shows.nsan = movies_shows_info.nsan
JOIN genre_map
ON movies_shows.nsan = genre_map.nsan
JOIN genre
ON genre_map.genre_id = genre.genre_id
ORDER BY title, release_year, genre_name;

SELECT * from genre_view;

CREATE OR REPLACE VIEW psychological_thriller_view AS
SELECT title as Title, release_year as Year_Of_Release, type as Type from movies_shows 
JOIN movies_shows_info
ON movies_shows.nsan = movies_shows_info.nsan
JOIN genre_map gm1
ON movies_shows.nsan = gm1.nsan
JOIN genre g1
ON gm1.genre_id = g1.genre_id
JOIN genre_map gm2
ON movies_shows.nsan = gm2.nsan
JOIN genre g2
ON gm2.genre_id = g2.genre_id
WHERE g1.genre_name = 'Psychological Fiction' AND g2.genre_name = 'Thriller';

SELECT * from psychological_thriller_view;

CREATE OR REPLACE VIEW trending_view AS
SELECT title as Title, release_year as Year_Of_Release, name as Actor_Actress, role from movies_shows 
JOIN cast_map
ON movies_shows.nsan = cast_map.nsan
JOIN person_info
ON person_info.person_id = cast_map.person_id
JOIN role_info
ON cast_map.role_id = role_info.role_id
LEFT JOIN (SELECT nsan, count(*) as count FROM
ratings 
GROUP BY nsan) AS trend
ON movies_shows.nsan = trend.nsan
ORDER BY trend.count desc;

SELECT * FROM trending_view;

CREATE OR REPLACE VIEW rating_view AS
SELECT title as Title, release_year as Year_Of_Release, avg(rating) as Rating from movies_shows
JOIN movies_shows_info
ON movies_shows.nsan = movies_shows_info.nsan
JOIN ratings
ON movies_shows.nsan = ratings.nsan
group by title, release_year
order by Rating desc;

SELECT * from rating_view;


-- Stored Procedures
-- (i)
DROP PROCEDURE IF EXISTS bo_calc;

delimiter $$
create procedure bo_calc(netTax INT, prodTax INT, distTax INT)
begin
    SELECT title, release_year, bo_gross as Gross, (bo_gross - bo_gross*(netTax/100)) as net_income, (bo_gross - bo_gross*(prodTax/100)) as production_income,
    (bo_gross - bo_gross*(distTax/100)) as distributor_income FROM movies_shows
    JOIN movies_shows_info
    ON movies_shows.nsan = movies_shows_info.nsan;
end$$
delimiter ;

call bo_calc(10, 40, 60);

-- (ii)

DROP PROCEDURE IF EXISTS user_rating_proc;
delimiter $$
create procedure user_rating_proc(userId VARCHAR(8))
begin
	SELECT distinct title as Title, release_year as Year, synopsis as Summary, name as Actor_Actress from movies_shows
    JOIN movies_shows_info
    ON movies_shows.nsan = movies_shows_info.nsan
	JOIN cast_map
	ON movies_shows.nsan = cast_map.nsan
    JOIN person_info
    ON cast_map.person_id = person_info.person_id
	WHERE (cast_map.person_id) IN
	(SELECT person_id from ratings
	JOIN cast_map
	ON ratings.nsan = cast_map.nsan
	WHERE rating > 5
	AND 
	user_id = userId)
	AND movies_shows.nsan NOT IN (SELECT nsan from ratings where
    user_id = userId)
    ORDER BY title;
end$$
delimiter ;


call user_rating_proc('USR1');


-- (iii)
DROP PROCEDURE IF EXISTS user_proc;
delimiter $$
create procedure user_proc(userId VARCHAR(8))
BEGIN 
	DECLARE userType VARCHAR(10);
    SELECT user_type INTO userType from user_info
    where user_id = userId;
    if(userType in ('Standard')) then
    call user_rating_proc(userId);
    SELECT * from movies_shows_awards_view;
    SELECT * from director_view;
    SELECT * from trending_view;
    SELECT * from genre_view;
    SELECT * from rating_view;
    SELECT * from psychological_thriller_view;
    end if;
end $$;
delimiter ;

call user_proc('USR1');


-- Queries


-- (i)
SELECT name as Actor_Actress, title, release_year, type as Type from movies_shows
JOIN cast_map 
ON movies_shows.nsan = cast_map.nsan
JOIN person_info 
ON person_info.person_id = cast_map.person_id
WHERE person_info.person_id in
(SELECT person_id from movies_shows
JOIN cast_map 
ON movies_shows.nsan = cast_map.nsan
WHERE type='TV'
AND person_info.person_id in
(SELECT person_id from movies_shows
JOIN cast_map 
ON movies_shows.nsan = cast_map.nsan
WHERE type='Movie'))
ORDER BY name, release_year; 

-- (ii)
SELECT title as Title, name as Actor, role, award_type, award_description, 
award_person_map.award_year from movies_shows
JOIN cast_map ON movies_shows.nsan = cast_map.nsan
JOIN role_info ON cast_map.role_id = role_info.role_id
JOIN person_info ON person_info.person_id = cast_map.person_id
JOIN award_person_map ON award_person_map.person_id = 
person_info.person_id
JOIN awards_map ON award_person_map.awards_map_id = 
awards_map.awards_map_id
AND movies_shows.nsan = awards_map.nsan
JOIN awards ON awards.award_id = awards_map.award_id
JOIN awards_info ON awards_info.awards_map_id = awards_map.awards_map_id
WHERE award_person_map.award_year IN
(SELECT MIN(award_person_map.award_year) FROM awards
JOIN awards_map ON awards_map.award_id = awards.award_id
JOIN awards_info ON awards_map.awards_map_id = awards_info.awards_map_id
JOIN award_person_map 
ON awards_info.awards_map_id = award_person_map.awards_map_id 
AND awards_info.award_year = award_person_map.award_year
JOIN person_info
ON award_person_map.person_id = person_info.person_id
where gender='Male' and award_type='Oscar');


-- (iii)
SELECT distinct title as Film, release_year, type as Type, p1.name as Actor1, p2.name as Actor2, relationship, relationship_year  FROM movies_shows
JOIN cast_map mc1 
ON movies_shows.nsan=mc1.nsan 
JOIN person_info p1 
ON mc1.person_id=p1.person_id
JOIN cast_map mc2 
ON movies_shows.nsan=mc2.nsan 
JOIN person_info p2 
ON mc2.person_id=p2.person_id
JOIN connections 
ON (p1.person_id=connections.actor1_id AND p2.person_id=connections.actor2_id)
WHERE (mc1.person_id, mc2.person_id) IN
(SELECT c1.actor1_id,c1.actor2_id as year_diff from connections c1
JOIN connections c2
ON c1.actor1_id = c2.actor1_id AND
c1.actor2_id = c2.actor2_id
WHERE c1.relationship != c2.relationship
AND c2.relationship = 'Divorced'
AND c2.relationship_year-c1.relationship_year IN
(SELECT MAX(year_diff) FROM
(SELECT c1.actor1_id,c1.actor2_id,c2.relationship_year-c1.relationship_year as year_diff from connections c1
JOIN connections c2
ON c1.actor1_id = c2.actor1_id AND
c1.actor2_id = c2.actor2_id
WHERE c1.relationship != c2.relationship
AND c2.relationship = 'Divorced') con))
order by title, relationship_year;


-- (iv)
SELECT name as Actor_Actress, COUNT(distinct category_id) as No_Of_Diverse_Roles from person_info
JOIN cast_map
ON cast_map.person_id = person_info.person_id
JOIN role_map
ON role_map.role_id = cast_map.role_id
group by name
HAVING No_Of_Diverse_Roles IN
(SELECT MAX(t.diverse_roles) FROM
(SELECT name, COUNT(distinct category_id) as diverse_roles from person_info
JOIN cast_map
ON cast_map.person_id = person_info.person_id
JOIN role_map
ON role_map.role_id = cast_map.role_id
group by name) t);




-- (v)
SELECT distinct title as Title, release_year as Year, synopsis as Summary, type as Type, genre_name from movies_shows 
JOIN movies_shows_info ON 
movies_shows.nsan = movies_shows_info.nsan
JOIN genre_map 
ON movies_shows.nsan = genre_map.nsan
JOIN genre 
ON genre.genre_id = genre_map.genre_id
WHERE (genre_map.genre_id) IN
(SELECT genre_id from ratings
JOIN genre_map 
ON ratings.nsan = genre_map.nsan
WHERE user_id = 'USR6'
AND rating> 5)
AND movies_shows.nsan NOT IN 
(SELECT nsan from ratings where
    user_id = 'USR6')
ORDER BY title, release_year;





-- (vi)
SELECT title as Title, release_year as Year_of_Release, role as Role, category as 
Category from movies_shows
JOIN movies_shows_info
ON movies_shows.nsan = movies_shows_info.nsan
JOIN cast_map
ON movies_shows.nsan = cast_map.nsan
JOIN role_info
ON cast_map.role_id = role_info.role_id
JOIN role_map
ON role_map.role_id = role_info.role_id
JOIN role_category
ON role_category.category_id = role_map.category_id
JOIN person_info
ON person_info.person_id = cast_map.person_id
where category = 'Detective';