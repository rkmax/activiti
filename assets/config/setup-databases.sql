-- create default user
CREATE USER dbuser;
-- Set password
ALTER ROLE dbuser PASSWORD 'dbuser';

-- Create databases
CREATE DATABASE monarch;
CREATE DATABASE activiti;

-- Allow user 'dbuser' to do anything
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public to dbuser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public to dbuser;
