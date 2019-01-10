TRUNCATE accounts;
TRUNCATE addressbook;

UPDATE `devices` SET `account_id`=0;
UPDATE `oauth_connections` SET `account_id`=0;
