USE prorec;

-- User_PrivilegeGroup
#Create table User_PrivilegeGroup
CREATE TABLE IF NOT EXISTS User_PrivilegeGroup (
    UserID BIGINT(8) UNSIGNED,
    GroupID BIGINT(8) UNSIGNED,
    FOREIGN KEY(GroupID) REFERENCES PrivilegeGroup(ID),
    FOREIGN KEY(UserID) REFERENCES User(ID),
    PRIMARY KEY(GroupID,UserID)
);

DELIMITER ;

#Create procedure sp_add_user_privilegegroup
DROP PROCEDURE IF EXISTS sp_add_user_privilegegroup;
DELIMITER $$
CREATE PROCEDURE sp_add_user_privilegegroup(
    IN iUserID BIGINT(8),
    IN iGroupID BIGINT(8)
)
BEGIN
	INSERT INTO User_PrivilegeGroup(UserID,GroupID) values(iUserID,iGroupID);
END$$

DELIMITER ;

#Create procedure sp_get_user_privilegegroup
DROP PROCEDURE IF EXISTS sp_get_user_privilegegroup;
DELIMITER $$
CREATE PROCEDURE sp_get_user_privilegegroup(
    IN iUserID BIGINT(8) UNSIGNED,
    IN iGroupID BIGINT(8) UNSIGNED
)
BEGIN

SELECT up.GroupID, pg.Name GroupName, up.UserID, u.Name UserName
FROM User_PrivilegeGroup up
INNER JOIN PrivilegeGroup pg ON up.GroupID=pg.ID
INNER JOIN User u ON up.UserID=u.ID
WHERE up.GroupID = iGroupID AND up.UserID = iUserID;

END$$

DELIMITER ;

#Create procedure sp_get_user_privilegegroup_by_userid
DROP PROCEDURE IF EXISTS sp_get_user_privilegegroup_by_userid;
DELIMITER $$
CREATE PROCEDURE sp_get_user_privilegegroup_by_userid(
    IN iUserID BIGINT(8) UNSIGNED
)
BEGIN

SELECT up.GroupID, pg.Name GroupName, up.UserID, u.Name UserName
FROM User_PrivilegeGroup up
INNER JOIN PrivilegeGroup pg ON up.GroupID=pg.ID
INNER JOIN User u ON up.UserID=u.ID
WHERE up.UserID = iUserID;

END$$

DELIMITER ;

#Create procedure sp_get_user_privilegegroup_by_groupid
DROP PROCEDURE IF EXISTS sp_get_user_privilegegroup_by_groupid;
DELIMITER $$
CREATE PROCEDURE sp_get_user_privilegegroup_by_groupid(
    IN iGroupID BIGINT(8) UNSIGNED
)
BEGIN

SELECT up.GroupID, pg.Name GroupName, up.UserID, u.Name UserName
FROM User_PrivilegeGroup up
INNER JOIN PrivilegeGroup pg ON up.GroupID=pg.ID
INNER JOIN User u ON up.UserID=u.ID
WHERE up.GroupID = iGroupID;

END$$

DELIMITER ;

#Create procedure sp_delete_user_privilegegroup
DROP PROCEDURE IF EXISTS sp_delete_user_privilegegroup;
DELIMITER $$
CREATE PROCEDURE sp_delete_user_privilegegroup(
    IN iUserID BIGINT(8) UNSIGNED,
    IN iGroupID BIGINT(8) UNSIGNED
)
BEGIN

DELETE FROM User_PrivilegeGroup WHERE GroupID = iGroupID AND UserID = iUserID;

END$$

DELIMITER ;