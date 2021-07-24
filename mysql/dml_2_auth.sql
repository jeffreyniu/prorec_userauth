USE prorec;

#Get admin user id
SET @UserId = -1;
SELECT ID INTO @UserId FROM User WHERE Name='admin' AND Enabled = TRUE;
SELECT @UserId;

#Add auth to admin user
SET @UserAuthId = -1;
CALL sp_add_user_auth(@UserId,'jefapiKey','jefapiSecret',date_add(NOW(), interval 10 year),@UserAuthId);
SELECT @UserAuthId;