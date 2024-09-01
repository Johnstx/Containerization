Create database homestead;
CREATE USER 'homestead'@'%' IDENTIFIED BY 'securepass';
GRANT ALL PRIVILEGES ON * . * TO 'homestead'@'%';
