USE prorec;

#Get admin user id
SET @UserId = -1;
SELECT ID INTO @UserId FROM User WHERE Name='admin' AND Enabled = TRUE;
SELECT @UserId;

#Add all privileges to admin group.
SELECT ID INTO @AdminGroupId FROM PrivilegeGroup WHERE Name = 'Admin';
SELECT @AdminGroupId;

#Add admin user to admin privilege group
CALL sp_add_user_privilegegroup(@UserId,@AdminGroupId);