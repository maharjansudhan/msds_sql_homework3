/*
This project is where you show off your ability to (1) translate a business requirement into a database design, (2) design
a database using one-to-many and many-to-many relationships, and (3) know when to use LEFT and/or RIGHT JOINs to
build result sets for reporting.

An organization grants key-card access to rooms based on groups that key-card holders belong to. You may assume that
users below to only one group. Your job is to design the database that supports the key-card system.
There are six users, and four groups. Modesto and Ayine are in group “I.T.” Christopher and Cheong woo are in group
“Sales”. There are four rooms: “101”, “102”, “Auditorium A”, and “Auditorium B”. Saulat is in group
“Administration.” Group “Operations” currently doesn’t have any users assigned. I.T. should be able to access Rooms
101 and 102. Sales should be able to access Rooms 102 and Auditorium A. Administration does not have access to any
rooms. Heidy is a new employee, who has not yet been assigned to any group.

After you determine the tables any relationships between the tables (One to many? Many to one? Many to many?), you
should create the tables and populate them with the information indicated above.

Next, write SELECT statements that provide the following information:
• All groups, and the users in each group. A group should appear even if there are no users assigned to the group.
• All rooms, and the groups assigned to each room. The rooms should appear even if no groups have been
assigned to them.
• A list of users, the groups that they belong to, and the rooms to which they are assigned. This should be sorted
alphabetically by user, then by group, then by room.

*/

# Since there is no schema mentioned I have created a schema with name "sql_homework3

#Create table for User
CREATE TABLE tblUsers
(
	user_id int PRIMARY KEY,
    firstname varchar(30) NOT NULL
);

INSERT INTO tblUsers (user_id, firstname) VALUES (1, 'Modesto');
INSERT INTO tblUsers (user_id, firstname) VALUES (2, 'Ayine');
INSERT INTO tblUsers (user_id, firstname) VALUES (3, 'Christopher');
INSERT INTO tblUsers (user_id, firstname) VALUES (4, 'Cheong woo');
INSERT INTO tblUsers (user_id, firstname) VALUES (5, 'Saulat');
INSERT INTO tblUsers (user_id, firstname) VALUES (6, 'Heidy');

SELECT * FROM tblUsers;

# Create table for Groups
CREATE TABLE tblGroups
(
	group_id int PRIMARY KEY,
	group_department varchar(30) NOT NULL
);

INSERT INTO tblGroups (group_id, group_department) VALUES (1, 'I.T.');
INSERT INTO tblGroups (group_id, group_department) VALUES (2, 'Sales');
INSERT INTO tblGroups (group_id, group_department) VALUES (3, 'Administration');
INSERT INTO tblGroups (group_id, group_department) VALUES (4, 'Operations');

SELECT * FROM tblGroups;

# create table for Rooms
CREATE TABLE tblRooms
(
	room_id int PRIMARY KEY,
    room_name varchar(20) NOT NULL
);

INSERT INTO tblRooms (room_id, room_name) VALUES (1, '101');
INSERT INTO tblRooms (room_id, room_name) VALUES (2, '102');
INSERT INTO tblRooms (room_id, room_name) VALUES (3, 'Auditorium A');
INSERT INTO tblRooms (room_id, room_name) VALUES (4, 'Auditorium B');

SELECT * FROM tblRooms;


#create new table referenceing the older ones
CREATE TABLE tblUsersGroups
(
	user_id int REFERENCES tblUsers,
    group_id int REFERENCES tblGroups
);

INSERT INTO tblUsersGroups (user_id, group_id) VALUES (1, 1);
INSERT INTO tblUsersGroups (user_id, group_id) VALUES (2, 1);
INSERT INTO tblUsersGroups (user_id, group_id) VALUES (3, 2);
INSERT INTO tblUsersGroups (user_id, group_id) VALUES (4, 2);
INSERT INTO tblUsersGroups (user_id, group_id) VALUES (5, 3);
INSERT INTO tblUsersGroups (user_id, group_id) VALUES (NULL, 4);
INSERT INTO tblUsersGroups (user_id, group_id) VALUES (6, NULL);

SELECT * FROM tblUsersGroups;

#create table from user room access
CREATE TABLE tblUserRoomAccess
(
	room_id int REFERENCES tblRooms,
    group_id int REFERENCES tblGroups
);

INSERT INTO tblUserRoomAccess (room_id, group_id) VALUES (1, 1);
INSERT INTO tblUserRoomAccess (room_id, group_id) VALUES (2, 1);
INSERT INTO tblUserRoomAccess (room_id, group_id) VALUES (2, 2);
INSERT INTO tblUserRoomAccess (room_id, group_id) VALUES (3, 2);
INSERT INTO tblUserRoomAccess (room_id, group_id) VALUES (NULL, 1);

SELECT * FROM tblUserRoomAccess;

/*
Next, write SELECT statements that provide the following information:

All groups, and the users in each group. 
A group should appear even if there are no users assigned to the group.
*/

SELECT 
tblUsers.user_id AS 'ID',
tblUsers.firstname AS 'Name',
tblGroups.group_department AS 'Groups'
FROM tblUsersGroups
LEFT JOIN tblUsers ON tblUsersGroups.user_id = tblUsers.user_id
LEFT JOIN tblGroups ON tblUsersGroups.group_id = tblGroups.group_id;


/*
All rooms, and the groups assigned to each room. 
The rooms should appear even if no groups have been
assigned to them.
*/

SELECT
tblRooms.room_id AS 'ID',
tblRooms.room_name AS 'Name',
tblGroups.group_department as 'Groups'
FROM tblUserRoomAccess
RIGHT JOIN tblRooms ON tblUserRoomAccess.room_id = tblRooms.room_id
LEFT JOIN tblGroups ON tblUserRoomAccess.group_id = tblGroups.group_id;


/*
A list of users, the groups that they belong to, and the rooms to which they are assigned. 
This should be sorted alphabetically by user, then by group, then by room.
*/

SELECT
tblUsers.user_id AS 'Id',
tblUsers.firstname AS 'Name',
tblGroups.group_department AS 'Group',
tblRooms.room_name AS 'Room'
FROM tblUsers
LEFT JOIN tblUsersGroups ON tblUsers.user_id = tblUsersGroups.user_id
LEFT JOIN tblGroups ON tblUsersGroups.group_id = tblGroups.group_id
LEFT JOIN tblUserRoomAccess ON tblGroups.group_id = tblUserRoomAccess.group_id
LEFT JOIN tblRooms ON tblUserRoomAccess.room_id = tblRooms.room_id
GROUP BY tblUsers.user_id, tblGroups.group_id, tblRooms.room_id
ORDER BY tblUsers.firstname, tblGroups.group_department, tblRooms.room_name;



