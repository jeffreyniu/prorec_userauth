USE prorec;

#Get privilege group id
SET @AdminGroupId = -1;
CALL sp_add_privilegegroup('Admin','Admin group for admin users.',@AdminGroupId);
SELECT @AdminGroupId;