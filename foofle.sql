-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Jun 14, 2020 at 05:33 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `foofle`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `block_user` (IN `blocked_user` VARCHAR(25))  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    if exists(select * from users where id = blocked_user)
    then
        begin 
            insert into block(owner, b_user) values (def_user, blocked_user);
        end;
    else 
        begin 
            select 'there is no such user';
        end;
    end if;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_rec_email` (IN `sender1` VARCHAR(25), IN `in_subject` VARCHAR(25))  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    if exists(select * from emails_new where receiver = def_user and subject = in_subject and sender = sender1)
    then
        begin
            UPDATE emails_new SET if_delete_receiver = '1' WHERE receiver = def_user and subject = in_subject and sender = sender1;
        end;
    else
        begin
            select 'there is no such email';
        end;
    end if;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_sent_email` (IN `receiver1` VARCHAR(25), IN `in_subject` VARCHAR(25))  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    if exists(select * from emails_new where sender = def_user and subject = in_subject and receiver = receiver1)
    then
        begin
            UPDATE emails_new SET if_delete_sender = '1' WHERE sender = def_user and subject = in_subject and receiver = receiver1;
        end;
    else
        begin
            select 'there is no such email';
        end;
    end if;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_user` ()  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    delete from users where id = def_user;
    delete from news where owner = def_user;
    delete from entries where last_user = def_user;
    delete from block where owner = def_user;
    delete from block where b_user = def_user;
    delete from emails_new where sender = def_user;
    delete from emails_new where receiver = def_user;
    delete from pro_emails where sender = def_user;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_dynamic_emails` ()  begin
    SELECT sender AS sender,
    COLUMN_JSON(receivers) AS 'getters',
    COLUMN_JSON(ccs) AS 'ccs',
    subject as 'subject',
    text as 'text'
    FROM pro_emails;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_info` ()  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    select id, fname, lname, phone, birthday, nickname, pitt_id, address, date_created from users where id = def_user;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_news` ()  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    select text from news where owner = def_user order by news_time desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_one_rec_email` (IN `sender1` VARCHAR(25), IN `subject1` VARCHAR(25))  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    if exists(select * from emails_new where receiver = def_user and subject = subject1 and sender = sender1)
    then
        begin
            select subject, text from emails_new where receiver = def_user and subject = subject1 and sender = sender1 LIMIT 1;
        end;
    else
        begin
            select 'there is no such email';
        end;
    end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_one_sent_email` (IN `receiver1` VARCHAR(25), IN `subject1` VARCHAR(25))  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    if exists(select * from emails_new where sender = def_user and subject = subject1 and receiver = receiver1)
    then
        begin
            select subject, text from emails_new where sender = def_user and subject = subject1 and receiver = receiver1 LIMIT 1;
        end;
    else
        begin
            select 'there is no such email';
        end;
    end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_others_info` (IN `username` VARCHAR(25))  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    if exists(select * from users where id = username)
    then
        begin
            if not exists(select * from block where owner= username and b_user = def_user)
            then
                begin
                    insert into news(owner, text, news_time)
                    values (username, concat(def_user, ' wanted to access your info and was access'), now());
                    select id, fname, lname, phone, birthday, nickname, pitt_id, address from users where id = username;
                end;
            else
                begin
                    insert into news(owner, text, news_time)
                    values (username, CONCAT(def_user, ' wanted to access your info and was declined access'), now());
                    select id, fname, lname, phone, '***' as birthday, nickname, pitt_id, address from users where id = '******';
                end;
            end if;
        end;
    else
        begin
            select 'there is no such user';
        end;
    end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rec_emails` (IN `page` INT)  begin
    declare def_user varchar(25);
    declare page_start INT;
    declare page_end INT;
    SET page_start = page - 1;
    SET page_end = page + 10;
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    select sender, subject, text, if_read_receiver from emails_new where receiver = def_user and if_delete_receiver = '0'
    order by email_time desc LIMIT page_start, page_end;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_sent_emails` (IN `page` INT)  begin
    declare def_user varchar(25);
    declare page_start INT;
    declare page_end INT;
    SET page_start = page - 1;
    SET page_end = page + 10;
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    select receiver, subject, text, if_read_sender from emails_new where sender = def_user and if_delete_sender = '0'
    order by email_time desc LIMIT page_start, page_end;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro2_create_email` (IN `getter1` VARCHAR(25), IN `getter2` VARCHAR(25), IN `getter3` VARCHAR(25), IN `cc1` VARCHAR(25), IN `cc2` VARCHAR(25), IN `cc3` VARCHAR(25), IN `text1` VARCHAR(25), IN `subject1` VARCHAR(25))  begin
    declare def_user varchar(25);
    declare getter10 varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    set getter10 = getter1;
    set getter10 = replace(getter10, '@foofle.com','');
    if exists(select * from users where id = getter10) or getter1 = ''
    then
        begin
            declare getter20 varchar(25);
            set getter20 = getter2;
            set getter20 = replace(getter20, '@foofle.com','');
            if exists(select * from users where id = getter20) or getter2 = ''
            then
                begin
                    declare getter30 varchar(25);
                    set getter30 = getter3;
                    set getter30 = replace(getter30, '@foofle.com','');
                    if exists(select * from users where id = getter30) or getter3 = ''
                    then
                        begin
                            declare cc10 varchar(25);
                            set cc10 = cc1;
                            set cc10 = replace(cc10, '@foofle.com','');
                            if exists(select * from users where id = cc10) or cc1 = ''
                            then
                                begin
                                    declare cc20 varchar(25);
                                    set cc20 = cc2;
                                    set cc20 = replace(cc20, '@foofle.com','');
                                    if exists(select * from users where id = cc20) or cc2 = ''
                                    then
                                        begin
                                            declare cc30 varchar(25);
                                            set cc30 = cc3;
                                            set cc30 = replace(cc30, '@foofle.com','');
                                            if exists(select * from users where id = cc30) or cc3 = ''
                                            then
                                                begin
                                                    insert into pro_emails (sender, receivers, ccs, subject, text, email_time)
                                                    values (def_user,COLUMN_CREATE('getter1', getter10, 'getter2', getter20,
                                                            'getter3', getter30),
                                                            COLUMN_CREATE('cc1', cc10, 'cc2', cc20, 'cc3', cc30),
                                                            subject1, text1, now());
                                                    if getter1 = ''
                                                    then
                                                        begin
                                                        end;
                                                    else
                                                        begin
                                                            insert into emails_new(sender, receiver, cc,
                                                                           if_read_sender,if_read_receiver,
                                                                           if_delete_sender, if_delete_receiver,
                                                                           subject, text, email_time)
                                                            values (def_user, getter10, '0', '0', '0', '0', '0',subject1, text1, now());
                                                        end;
                                                    end if;
                                                    if getter2 = ''
                                                    then
                                                        begin
                                                        end;
                                                    else
                                                        begin
                                                            insert into emails_new(sender, receiver, cc,
                                                                           if_read_sender,if_read_receiver,
                                                                           if_delete_sender, if_delete_receiver,
                                                                           subject, text, email_time)
                                                            values (def_user, getter20, '0', '0', '0', '0', '0',subject1, text1, now());
                                                        end;
                                                    end if;
                                                    if getter3 = ''
                                                    then
                                                        begin
                                                        end;
                                                    else
                                                        begin
                                                            insert into emails_new(sender, receiver, cc,
                                                                           if_read_sender,if_read_receiver,
                                                                           if_delete_sender, if_delete_receiver,
                                                                           subject, text, email_time)
                                                            values (def_user, getter30, '0', '0', '0', '0', '0',subject1, text1, now());
                                                        end;
                                                    end if;
                                                    if cc1 = ''
                                                    then
                                                        begin
                                                        end;
                                                    else
                                                        begin
                                                            insert into emails_new(sender, receiver, cc,
                                                                           if_read_sender,if_read_receiver,
                                                                           if_delete_sender, if_delete_receiver,
                                                                           subject, text, email_time)
                                                            values (def_user, cc10, '1', '0', '0', '0', '0',subject1, text1, now());
                                                        end;
                                                    end if;
                                                    if cc2 = ''
                                                    then
                                                        begin
                                                        end;
                                                    else
                                                        begin
                                                            insert into emails_new(sender, receiver, cc,
                                                                           if_read_sender,if_read_receiver,
                                                                           if_delete_sender, if_delete_receiver,
                                                                           subject, text, email_time)
                                                            values (def_user, cc20, '1', '0', '0', '0', '0',subject1, text1, now());
                                                        end;
                                                    end if;
                                                    if cc3 = ''
                                                    then
                                                        begin
                                                        end;
                                                    else
                                                        begin
                                                            insert into emails_new(sender, receiver, cc,
                                                                           if_read_sender,if_read_receiver,
                                                                           if_delete_sender, if_delete_receiver,
                                                                           subject, text, email_time)
                                                            values (def_user, cc30, '1', '0', '0', '0', '0',subject1, text1, now());
                                                        end;
                                                    end if;
                                                end;
                                            else
                                                begin
                                                    select 'cc3 is not valid';
                                                end;
                                            end if;
                                        end;
                                    else
                                        begin
                                            select 'cc2 is not valid';
                                        end;
                                    end if;
                                end;
                            else
                                begin
                                    select 'cc1 is not valid';
                                end;
                            end if;
                        end;
                    else
                        begin
                            select 'getter3 is not valid';
                        end;
                    end if;
                end;
            else
                begin
                    select 'getter2 is not valid';
                end;
            end if;
        end;
    else
        begin
            select 'getter1 is not valid';
        end;
    end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_create_user` (IN `id1` VARCHAR(25), IN `fname1` VARCHAR(25), IN `lname1` VARCHAR(25), IN `phone1` VARCHAR(25), IN `birthday1` VARCHAR(25), IN `nickname1` VARCHAR(25), IN `pitt_id1` VARCHAR(25), IN `password1` VARCHAR(25), IN `address1` VARCHAR(25))  begin
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    SELECT 'your information is either invalid or incomplete';
    END;
    if not exists(select id from users where id = lower(id1))
    then
        begin
            if id1 like '______%'
            then
                begin
                    if password1 like '______%'
                    then
                            begin
                                insert into users(id, fname, lname, phone, birthday, nickname, pitt_id, password, address, date_created)
                                values (id1, fname1, lname1, phone1, birthday1, nickname1, pitt_id1, MD5(password1), address1, now());
                            end;
                    else
                        begin
                            select 'password is invalid';
                        end;
                    end if;
                end;
            else
                begin
                    select 'username is invalid';
                end;
            end if;
        end;
    else
        begin
            select 'user already exists';
        end;
    end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_login` (IN `username` VARCHAR(25), IN `pass` VARCHAR(25))  begin
    if exists(select id from users where id = username and password = MD5(pass))
    then
        begin
            insert into entries(last_user, date_entered) values (username, now());
        end;
    else
        begin
            select 'entered data is incorrect';
        end;
    end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_rec_email` (IN `sender1` VARCHAR(25), IN `email_subject` VARCHAR(25))  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    if exists(select * from emails_new where receiver = def_user and subject = email_subject and sender = sender1)
    then
        begin
            update emails_new set if_read_receiver = '1' where receiver = def_user and subject = email_subject and sender = sender1;
        end;
    else
        begin
            select 'there is no such email';
        end;
    end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_sent_email` (IN `receiver1` VARCHAR(25), IN `email_subject` VARCHAR(25))  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    if exists(select * from emails_new where sender = def_user and subject = email_subject and receiver = receiver1)
    then
        begin
            update emails_new set if_read_sender = '1' where sender = def_user and subject = email_subject and receiver = receiver1;
        end;
    else
        begin
            select 'there is no such email';
        end;
    end if;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_info` (IN `fname` VARCHAR(25), IN `lname` VARCHAR(25), IN `phone` VARCHAR(25), IN `birthday` VARCHAR(25), IN `nickname` VARCHAR(25), IN `pitt_id` VARCHAR(25), IN `password` VARCHAR(25), IN `address` VARCHAR(25))  begin
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    if(fname = '')
    then
        begin
        end;
    else
        begin
            update users SET fname = fname WHERE id = def_user;
        end;
    end if;
    if(lname = '')
    then
        begin
        end;
    else
        begin
            update users SET lname = lname WHERE id = def_user;
        end;
    end if;
    if(phone = '')
    then
        begin
        end;
    else
        begin
            update users SET phone = phone WHERE id = def_user;
        end;
    end if;
    if(birthday = '')
    then
        begin
        end;
    else
        begin
            update users SET birthday = birthday WHERE id = def_user;
        end;
    end if;
    if(nickname = '')
    then
        begin
        end;
    else
        begin
            update users SET nickname = nickname WHERE id = def_user;
        end;
    end if;
    if(pitt_id = '')
    then
        begin
        end;
    else
        begin
            update users SET pitt_id = pitt_id WHERE id = def_user;
        end;
    end if;
    if(password = '')
    then
        begin
        end;
    else
        begin
            if password not like '%[^0-9a-z]%' and password like '______%'
            then
                begin
                    update users SET password = MD5(password) WHERE id = def_user;
                end;
            else
                begin
                    select 'password is invalid';
                end;
            end if;
        end;
    end if;
    if(address = '')
    then
        begin
        end;
    else
        begin
            update users SET address = address WHERE id = def_user;
        end;
    end if;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `block`
--

CREATE TABLE `block` (
  `owner` varchar(25) NOT NULL,
  `b_user` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `block`
--

INSERT INTO `block` (`owner`, `b_user`) VALUES
('oplo34', 'qwerty'),
('qwerty', 'oplo34'),
('qwerty', 'kasra2024');

-- --------------------------------------------------------

--
-- Table structure for table `emails_new`
--

CREATE TABLE `emails_new` (
  `sender` varchar(25) NOT NULL,
  `receiver` varchar(25) NOT NULL,
  `cc` varchar(10) NOT NULL,
  `if_read_sender` varchar(10) NOT NULL,
  `if_read_receiver` varchar(10) NOT NULL,
  `if_delete_sender` varchar(10) NOT NULL,
  `if_delete_receiver` varchar(10) NOT NULL,
  `subject` varchar(25) DEFAULT NULL,
  `text` varchar(100) DEFAULT NULL,
  `email_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `emails_new`
--

INSERT INTO `emails_new` (`sender`, `receiver`, `cc`, `if_read_sender`, `if_read_receiver`, `if_delete_sender`, `if_delete_receiver`, `subject`, `text`, `email_time`) VALUES
('nicolas', 'qwerty', '0', '1', '1', '0', '0', 'dead', 'popo is dead', '2020-06-13 16:15:48'),
('nicolas', 'kasra2024', '0', '1', '1', '0', '0', 'dead', 'popo is dead', '2020-06-13 16:15:49'),
('nicolas', 'qwerty369', '0', '1', '0', '0', '0', 'dead', 'popo is dead', '2020-06-13 16:15:49'),
('nicolas', 'kasra2024', '1', '1', '1', '0', '0', 'dead', 'popo is dead', '2020-06-13 16:15:49'),
('nicolas', 'popo123', '1', '1', '0', '0', '0', 'dead', 'popo is dead', '2020-06-13 16:15:49'),
('nicolas', 'qwerty852', '1', '1', '0', '0', '0', 'dead', 'popo is dead', '2020-06-13 16:15:49'),
('qwerty', 'kasra2024', '0', '0', '0', '0', '0', 'alive', 'he was alive', '2020-06-13 16:16:49'),
('qwerty', 'oplo34', '0', '0', '0', '0', '0', 'dead', 'popo is dead', '2020-06-13 23:29:31'),
('qwerty', 'qwerty369', '0', '0', '0', '0', '0', 'dead', 'popo is dead', '2020-06-13 23:29:31'),
('qwerty', 'kasra2024', '1', '0', '0', '0', '0', 'dead', 'popo is dead', '2020-06-13 23:29:31'),
('qwerty', 'popo123', '1', '0', '0', '0', '0', 'dead', 'popo is dead', '2020-06-13 23:29:31'),
('qwerty', 'qwerty852', '1', '0', '0', '0', '0', 'dead', 'popo is dead', '2020-06-13 23:29:31'),
('qwerty', 'oplo34', '0', '1', '0', '0', '0', 'fire', 'paris is on fire', '2020-06-13 23:36:21'),
('qwerty', 'kasra2024', '1', '0', '0', '0', '0', 'fire', 'paris is on fire', '2020-06-13 23:36:21'),
('qwerty', 'popo123', '1', '0', '0', '0', '0', 'fire', 'paris is on fire', '2020-06-13 23:36:21'),
('qwerty', 'nicolas', '0', '0', '0', '0', '0', 'kipo has been shot', 'kipo is dead', '2020-06-14 19:10:46'),
('qwerty', 'qwerty', '1', '1', '1', '0', '0', 'kipo has been shot', 'kipo is dead', '2020-06-14 19:10:46');

--
-- Triggers `emails_new`
--
DELIMITER $$
CREATE TRIGGER `deleted_email_trigger` AFTER UPDATE ON `emails_new` FOR EACH ROW begin
    if (NEW.if_delete_receiver = '1')
    then
        begin
            insert into news(owner, text, news_time) values(NEW.receiver, 'you have deleted an email', NOW());
        end;
    end if;
    if (NEW.if_delete_sender = '1')
    then
        begin
            insert into news(owner, text, news_time) values(NEW.sender, 'you have deleted an email', NOW());
        end;
    end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `new_email_trigger` AFTER INSERT ON `emails_new` FOR EACH ROW begin
    insert into news(owner, text, news_time) values(NEW.sender, 'you have a new email', NOW());
    insert into news(owner, text, news_time) values(NEW.receiver, 'you have a new email', NOW());
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `entries`
--

CREATE TABLE `entries` (
  `last_user` varchar(25) NOT NULL,
  `date_entered` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `entries`
--

INSERT INTO `entries` (`last_user`, `date_entered`) VALUES
('qwerty', '2020-06-10 23:07:50'),
('qwerty', '2020-06-10 23:12:31'),
('qwerty', '2020-06-11 11:58:59'),
('qwerty', '2020-06-12 16:57:59'),
('qwerty', '2020-06-12 17:01:44'),
('qwerty', '2020-06-12 23:12:55'),
('qwerty', '2020-06-12 23:22:18'),
('qwerty', '2020-06-12 23:25:29'),
('qwerty', '2020-06-12 23:26:58'),
('qwerty', '2020-06-12 23:29:32'),
('qwerty', '2020-06-12 23:30:42'),
('qwerty', '2020-06-13 00:47:30'),
('qwerty', '2020-06-13 11:11:42'),
('qwerty', '2020-06-13 12:18:20'),
('qwerty', '2020-06-13 12:25:46'),
('qwerty', '2020-06-13 15:07:46'),
('qwerty', '2020-06-13 15:14:22'),
('qwerty', '2020-06-13 15:15:03'),
('jack123', '2020-06-13 15:34:43'),
('nicolas', '2020-06-13 15:36:16'),
('nicolas', '2020-06-13 17:02:52'),
('nicolas', '2020-06-13 17:08:59'),
('nicolas', '2020-06-13 17:11:20'),
('nicolas', '2020-06-13 17:14:45'),
('nicolas', '2020-06-13 17:21:27'),
('nicolas', '2020-06-13 17:24:50'),
('nicolas', '2020-06-13 17:27:38'),
('nicolas', '2020-06-13 17:32:23'),
('nicolas', '2020-06-13 17:34:24'),
('nicolas', '2020-06-13 17:35:29'),
('nicolas', '2020-06-13 17:37:53'),
('nicolas', '2020-06-13 17:38:41'),
('nicolas', '2020-06-13 17:39:15'),
('qwerty', '2020-06-13 17:45:06'),
('nicolas', '2020-06-13 17:46:02'),
('nicolas', '2020-06-13 17:46:42'),
('nicolas', '2020-06-13 17:47:00'),
('nicolas', '2020-06-13 17:53:29'),
('nicolas', '2020-06-13 17:54:48'),
('nicolas', '2020-06-13 17:56:52'),
('nicolas', '2020-06-13 17:58:18'),
('nicolas', '2020-06-13 17:59:51'),
('qwerty', '2020-06-13 18:00:55'),
('qwerty', '2020-06-13 21:43:44'),
('qwerty', '2020-06-13 21:44:10'),
('qwerty', '2020-06-13 21:59:28'),
('qwerty', '2020-06-13 22:05:08'),
('qwerty', '2020-06-13 22:15:00'),
('qwerty', '2020-06-14 08:44:38'),
('qwerty', '2020-06-14 09:37:02'),
('qwerty', '2020-06-14 09:47:54'),
('qwerty', '2020-06-14 09:49:24'),
('qwerty', '2020-06-14 09:53:55'),
('qwerty', '2020-06-14 10:00:30'),
('qwerty', '2020-06-14 19:08:57'),
('nicolas', '2020-06-14 19:13:22'),
('qwerty', '2020-06-14 19:14:01'),
('qwerty', '2020-06-14 19:18:28'),
('qwerty', '2020-06-14 19:20:58'),
('qwerty', '2020-06-14 19:21:37'),
('qwerty', '2020-06-14 19:23:18'),
('qwerty', '2020-06-14 19:23:51'),
('qwerty', '2020-06-14 19:24:52'),
('qwerty', '2020-06-14 19:28:40'),
('qwerty', '2020-06-14 19:30:30'),
('qwerty', '2020-06-14 19:30:57'),
('qwerty', '2020-06-14 19:31:50'),
('qwerty', '2020-06-14 19:34:45');

--
-- Triggers `entries`
--
DELIMITER $$
CREATE TRIGGER `login_news` AFTER INSERT ON `entries` FOR EACH ROW begin
    insert into news(owner, text, news_time) values(NEW.last_user, 'you have logged in', NOW());
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `owner` varchar(25) NOT NULL,
  `text` varchar(100) DEFAULT NULL,
  `news_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `news`
--

INSERT INTO `news` (`owner`, `text`, `news_time`) VALUES
('qwerty', 'you have logged in', '2020-05-29 02:25:55'),
('oplo34', 'you have a new email', '2020-05-29 02:26:31'),
('qwerty', 'you have logged in', '2020-05-29 02:27:01'),
('kasra2024', 'you have a new email', '2020-05-29 02:27:16'),
('oplo34', 'you have a new email', '2020-05-29 02:27:16'),
('kasra2024', 'you have a new email', '2020-05-29 02:27:43'),
('oplo34', 'you have a new email', '2020-05-29 02:27:43'),
('234567', 'you have a new email', '2020-05-29 02:27:43'),
('qwerty', 'you have logged in', '2020-05-29 02:28:52'),
('oplo34', 'you have a new email', '2020-05-29 02:28:57'),
('oplo34', 'you have a new email', '2020-05-29 02:29:05'),
('qwerty', 'you have logged in', '2020-05-29 02:29:47'),
('oplo34', 'you have a new email', '2020-05-29 02:29:54'),
('234567', 'you have a new email', '2020-05-29 02:29:54'),
('qwerty', 'you have logged in', '2020-05-29 02:31:01'),
('oplo34', 'you have a new email', '2020-05-29 02:31:07'),
('oplo34', 'you have a new email', '2020-05-29 02:31:20'),
('qwerty', 'you have logged in', '2020-05-29 02:49:52'),
('oplo34', 'you have a new email', '2020-05-29 02:50:09'),
('oplo34', 'you have a new email', '2020-05-29 02:51:48'),
('qwerty', 'you have logged in', '2020-05-29 12:24:34'),
('qwerty', 'you have logged in', '2020-05-29 12:34:03'),
('qwerty', 'you have logged in', '2020-05-29 12:50:17'),
('qwerty', 'you have logged in', '2020-05-29 12:55:56'),
('qwerty', 'you have logged in', '2020-05-29 13:02:06'),
('qwerty', 'you have logged in', '2020-05-29 13:04:27'),
('qwerty', 'you have logged in', '2020-05-29 13:07:58'),
('qwerty', 'you have a new email', '2020-05-29 14:53:46'),
('qwerty', 'you have a new email', '2020-05-29 14:54:23'),
('qwerty', 'you have logged in', '2020-05-29 14:54:30'),
('qwerty', 'you have logged in', '2020-05-29 14:56:21'),
('qwerty', 'you have logged in', '2020-05-29 14:57:13'),
('qwerty', 'you have logged in', '2020-05-29 14:57:52'),
('qwerty', 'you have logged in', '2020-05-29 14:59:38'),
('qwerty', 'you have logged in', '2020-05-29 15:00:10'),
('qwerty', 'you have logged in', '2020-05-29 15:00:51'),
('qwerty', 'you have logged in', '2020-05-29 15:03:18'),
('qwerty', 'you have logged in', '2020-05-29 15:15:47'),
('qwerty', 'you have logged in', '2020-05-29 15:21:33'),
('qwerty', 'you have logged in', '2020-05-29 15:23:23'),
('qwerty', 'you have logged in', '2020-05-29 15:36:42'),
('qwerty', 'you have logged in', '2020-05-29 15:37:53'),
('qwerty', 'you have logged in', '2020-05-29 15:39:47'),
('qwerty', 'you have logged in', '2020-05-29 15:41:30'),
('qwerty', 'you have logged in', '2020-05-29 15:55:43'),
('qwerty', 'you have logged in', '2020-05-29 15:57:32'),
('qwerty', 'you have logged in', '2020-05-29 16:00:22'),
('qwerty', 'you have logged in', '2020-05-29 16:15:07'),
('qwerty', 'you have logged in', '2020-05-29 16:20:45'),
('qwerty', 'you have logged in', '2020-05-29 16:24:34'),
('qwerty', 'you have logged in', '2020-05-29 16:25:12'),
('qwerty', 'you have logged in', '2020-05-29 16:26:54'),
('qwerty', 'you have logged in', '2020-05-29 16:28:48'),
('qwerty', 'you have logged in', '2020-05-29 16:29:37'),
('qwerty', 'you have logged in', '2020-05-29 16:30:49'),
('qwerty', 'you have logged in', '2020-05-29 16:31:50'),
('qwerty', 'you have logged in', '2020-05-29 16:33:31'),
('qwerty', 'you have logged in', '2020-05-29 16:35:22'),
('qwerty', 'you have logged in', '2020-05-29 16:36:17'),
('qwerty', 'you have logged in', '2020-05-29 16:38:11'),
('qwerty', 'you have logged in', '2020-05-29 16:40:02'),
('qwerty', 'you have logged in', '2020-06-08 22:40:54'),
('qwerty', 'you have logged in', '2020-06-08 22:41:36'),
('qwerty', 'you have logged in', '2020-06-09 14:16:43'),
('qwerty', 'you have logged in', '2020-06-09 14:31:25'),
('qwerty', 'you have signed up', '2020-06-09 23:04:35'),
('qwerty', 'you have logged in', '2020-06-09 23:12:55'),
('qwerty', 'you have logged in', '2020-06-09 23:13:43'),
('qwerty', 'you changed your info', '2020-06-09 23:52:09'),
('qwerty', 'you changed your info', '2020-06-10 00:00:40'),
('qwerty', 'you changed your info', '2020-06-10 00:04:05'),
('qwerty', 'you changed your info', '2020-06-10 00:04:11'),
('qwerty', 'you changed your info', '2020-06-10 00:04:21'),
('qwerty', 'you changed your info', '2020-06-10 00:04:21'),
('qwerty', 'you changed your info', '2020-06-10 00:04:23'),
('qwerty', 'you changed your info', '2020-06-10 00:04:23'),
('qwerty', 'you changed your info', '2020-06-10 00:04:30'),
('qwerty', 'you changed your info', '2020-06-10 00:04:30'),
('qwerty', 'you changed your info', '2020-06-10 00:04:32'),
('qwerty', 'you changed your info', '2020-06-10 00:04:32'),
('qwerty', 'you changed your info', '2020-06-10 00:04:49'),
('qwerty', 'you changed your info', '2020-06-10 00:04:49'),
('qwerty', 'you changed your info', '2020-06-10 00:04:55'),
('qwerty', 'you changed your info', '2020-06-10 00:04:55'),
('qwerty', 'you changed your info', '2020-06-10 00:04:56'),
('qwerty', 'you changed your info', '2020-06-10 00:04:56'),
('qwerty', 'you changed your info', '2020-06-10 00:05:08'),
('qwerty', 'you changed your info', '2020-06-10 00:05:08'),
('qwerty', 'you changed your info', '2020-06-10 00:05:18'),
('qwerty', 'you changed your info', '2020-06-10 00:05:18'),
('qwerty', 'you changed your info', '2020-06-10 00:05:29'),
('poli', 'you have logged in', '2020-06-10 00:12:24'),
('oplo34', 'you changed your info', '2020-06-10 00:13:18'),
('oplo34', 'you changed your info', '2020-06-10 00:13:18'),
('qwerty', 'you have logged in', '2020-06-10 00:15:45'),
('qwerty', 'you have logged in', '2020-06-10 00:27:27'),
('qwerty', 'you changed your info', '2020-06-10 00:27:44'),
('qwerty', 'you have logged in', '2020-06-10 00:29:34'),
('qwerty', 'you changed your info', '2020-06-10 00:29:50'),
('qwerty', 'you have logged in', '2020-06-10 00:43:45'),
('qwerty', 'you have logged in', '2020-06-10 01:06:27'),
('qwerty', 'you have logged in', '2020-06-10 01:14:52'),
('qwerty', 'you have logged in', '2020-06-10 01:15:18'),
('qwerty', 'you have logged in', '2020-06-10 22:35:23'),
('qwerty', 'you have logged in', '2020-06-10 22:44:11'),
('qwerty', 'you have logged in', '2020-06-10 23:07:04'),
('qwerty', 'you have logged in', '2020-06-10 23:07:50'),
('qwerty', 'you have logged in', '2020-06-10 23:12:31'),
('arqavan', 'you have a new email', '2020-06-11 11:50:43'),
('kasra', 'you have a new email', '2020-06-11 11:50:43'),
('nastooh', 'you have a new email', '2020-06-11 11:50:43'),
('qwerty', 'you have logged in', '2020-06-11 11:58:59'),
('kasra2024', 'you have a new email', '2020-06-11 13:50:05'),
('kasra2024', 'you have a new email', '2020-06-11 14:41:27'),
('qwerty', 'you have a new email', '2020-06-11 14:45:06'),
('qwerty', 'you have a new email', '2020-06-11 14:45:11'),
('qwerty', 'you have a new email', '2020-06-11 15:07:19'),
('qwerty', 'you have a new email', '2020-06-11 15:08:14'),
('kasra2024', 'you have a new email', '2020-06-11 15:08:14'),
('oplo34', 'you have a new email', '2020-06-11 15:08:14'),
('qwerty', 'you have logged in', '2020-06-12 16:57:59'),
('qwerty', 'you changed your info', '2020-06-12 16:58:23'),
('qwerty', 'you have logged in', '2020-06-12 17:01:44'),
('qwerty', 'you have logged in', '2020-06-12 23:12:55'),
('qwerty', 'you have logged in', '2020-06-12 23:22:18'),
('qwerty', 'you have logged in', '2020-06-12 23:25:29'),
('qwerty', 'you have logged in', '2020-06-12 23:26:58'),
('qwerty', 'you have logged in', '2020-06-12 23:29:32'),
('qwerty', 'you have logged in', '2020-06-12 23:30:42'),
('qwerty', 'you have a new email', '2020-06-12 23:50:08'),
('kasra2024', 'you have a new email', '2020-06-12 23:50:08'),
('qwerty369', 'you have a new email', '2020-06-12 23:50:08'),
('kasra2024', 'you have a new email', '2020-06-12 23:50:08'),
('popo123', 'you have a new email', '2020-06-12 23:50:08'),
('qwerty852', 'you have a new email', '2020-06-12 23:50:08'),
('qwerty', 'you have logged in', '2020-06-13 00:47:30'),
('qwerty', 'you have logged in', '2020-06-13 11:11:42'),
('qwerty', 'you have logged in', '2020-06-13 12:18:20'),
('qwerty', 'you have logged in', '2020-06-13 12:25:46'),
('qwerty', 'you have logged in', '2020-06-13 15:07:46'),
('qwerty', 'you have logged in', '2020-06-13 15:14:22'),
('qwerty', 'you have logged in', '2020-06-13 15:15:03'),
('jack123', 'you have signed up', '2020-06-13 15:34:35'),
('jack123', 'you have logged in', '2020-06-13 15:34:43'),
('nicolas', 'you have signed up', '2020-06-13 15:36:09'),
('nicolas', 'you have logged in', '2020-06-13 15:36:16'),
('kasra2024', 'you have a new email', '2020-06-13 15:54:14'),
('nicolas', 'you have a new email', '2020-06-13 15:54:14'),
('jack123', 'you have a new email', '2020-06-13 15:54:14'),
('nicolas', 'you have a new email', '2020-06-13 15:54:14'),
('oplo34', 'you have a new email', '2020-06-13 15:54:14'),
('qwerty', 'you have a new email', '2020-06-13 15:54:14'),
('kasra2024', 'you have logged in', '2020-06-13 16:39:28'),
('nicolas', 'you have logged in', '2020-06-13 17:02:52'),
('nicolas', 'you have logged in', '2020-06-13 17:08:59'),
('nicolas', 'you have logged in', '2020-06-13 17:11:20'),
('nicolas', 'you have logged in', '2020-06-13 17:14:45'),
('nicolas', 'you have logged in', '2020-06-13 17:21:27'),
('nicolas', 'you have logged in', '2020-06-13 17:24:50'),
('nicolas', 'you have logged in', '2020-06-13 17:27:38'),
('nicolas', 'you have logged in', '2020-06-13 17:32:23'),
('nicolas', 'you have logged in', '2020-06-13 17:34:24'),
('nicolas', 'you have logged in', '2020-06-13 17:35:29'),
('nicolas', 'you have logged in', '2020-06-13 17:37:53'),
('nicolas', 'you have logged in', '2020-06-13 17:38:41'),
('nicolas', 'you have logged in', '2020-06-13 17:39:15'),
('qwerty', 'you have logged in', '2020-06-13 17:45:06'),
('nicolas', 'you have logged in', '2020-06-13 17:46:02'),
('nicolas', 'you have logged in', '2020-06-13 17:46:42'),
('nicolas', 'you have logged in', '2020-06-13 17:47:00'),
('nicolas', 'you have logged in', '2020-06-13 17:53:29'),
('nicolas', 'you have logged in', '2020-06-13 17:54:48'),
('nicolas', 'you have logged in', '2020-06-13 17:56:52'),
('nicolas', 'you have logged in', '2020-06-13 17:58:18'),
('nicolas', 'you have logged in', '2020-06-13 17:59:51'),
('qwerty', 'you have logged in', '2020-06-13 18:00:55'),
('nicolas', 'you have deleted an email', '2020-06-13 19:58:19'),
('popo123', 'you have deleted an email', '2020-06-13 19:58:54'),
('qwerty', 'you have a new email', '2020-06-13 20:05:59'),
('kasra2024', 'you have a new email', '2020-06-13 20:05:59'),
('qwerty', 'you have logged in', '2020-06-13 21:43:44'),
('qwerty', 'you have logged in', '2020-06-13 21:44:10'),
('oplo34', 'qwerty wanted to access your info and was declined access', '2020-06-13 21:51:32'),
('qwerty', 'you have logged in', '2020-06-13 21:59:28'),
('qwerty', 'you have logged in', '2020-06-13 22:05:08'),
('oplo34', 'qwerty wanted to access your info and was declined access', '2020-06-13 22:12:30'),
('oplo34', 'qwerty wanted to access your info and was declined access', '2020-06-13 22:12:58'),
('qwerty', 'you have logged in', '2020-06-13 22:15:00'),
('kolikoli123', 'you have signed up', '2020-06-13 22:51:56'),
('asdfasdf', 'you have signed up', '2020-06-13 22:52:38'),
('kolkol90', 'you have signed up', '2020-06-13 23:18:06'),
('qwerty', 'you have a new email', '2020-06-13 23:29:31'),
('', 'you have a new email', '2020-06-13 23:29:31'),
('qwerty', 'you have a new email', '2020-06-13 23:29:31'),
('oplo34', 'you have a new email', '2020-06-13 23:29:31'),
('qwerty', 'you have a new email', '2020-06-13 23:29:31'),
('qwerty369', 'you have a new email', '2020-06-13 23:29:31'),
('qwerty', 'you have a new email', '2020-06-13 23:29:31'),
('kasra2024', 'you have a new email', '2020-06-13 23:29:31'),
('qwerty', 'you have a new email', '2020-06-13 23:29:31'),
('popo123', 'you have a new email', '2020-06-13 23:29:31'),
('qwerty', 'you have a new email', '2020-06-13 23:29:31'),
('qwerty852', 'you have a new email', '2020-06-13 23:29:31'),
('qwerty', 'you have a new email', '2020-06-13 23:36:21'),
('oplo34', 'you have a new email', '2020-06-13 23:36:21'),
('qwerty', 'you have a new email', '2020-06-13 23:36:21'),
('kasra2024', 'you have a new email', '2020-06-13 23:36:21'),
('qwerty', 'you have a new email', '2020-06-13 23:36:21'),
('popo123', 'you have a new email', '2020-06-13 23:36:21'),
('qwerty', 'you have logged in', '2020-06-14 08:44:38'),
('kasra2024', 'qwerty wanted to access your info and was access', '2020-06-14 09:33:50'),
('qwerty', 'you have logged in', '2020-06-14 09:37:02'),
('qwerty', 'you have logged in', '2020-06-14 09:47:54'),
('qwerty', 'you have logged in', '2020-06-14 09:49:24'),
('qwerty', 'you have logged in', '2020-06-14 09:53:55'),
('qwerty', 'you have logged in', '2020-06-14 10:00:30'),
('qwerty', 'you have logged in', '2020-06-14 19:08:57'),
('oplo34', 'qwerty wanted to access your info and was declined access', '2020-06-14 19:09:39'),
('qwerty', 'you have a new email', '2020-06-14 19:10:46'),
('nicolas', 'you have a new email', '2020-06-14 19:10:46'),
('qwerty', 'you have a new email', '2020-06-14 19:10:46'),
('qwerty', 'you have a new email', '2020-06-14 19:10:46'),
('nicolas', 'you have logged in', '2020-06-14 19:13:22'),
('qwerty', 'you have logged in', '2020-06-14 19:14:01'),
('qwerty', 'you have logged in', '2020-06-14 19:18:28'),
('qwerty', 'you have logged in', '2020-06-14 19:20:58'),
('qwerty', 'you have logged in', '2020-06-14 19:21:37'),
('qwerty', 'you have logged in', '2020-06-14 19:23:18'),
('qwerty', 'you have logged in', '2020-06-14 19:23:51'),
('qwerty', 'you have logged in', '2020-06-14 19:24:52'),
('qwerty', 'you have logged in', '2020-06-14 19:28:40'),
('qwerty', 'you have logged in', '2020-06-14 19:30:30'),
('qwerty', 'you have logged in', '2020-06-14 19:30:57'),
('qwerty', 'you have logged in', '2020-06-14 19:31:50'),
('qwerty', 'you have logged in', '2020-06-14 19:34:45');

-- --------------------------------------------------------

--
-- Table structure for table `pro_emails`
--

CREATE TABLE `pro_emails` (
  `id` int(11) NOT NULL,
  `sender` varchar(25) NOT NULL,
  `receivers` blob DEFAULT NULL,
  `ccs` blob DEFAULT NULL,
  `subject` varchar(25) NOT NULL,
  `text` varchar(100) NOT NULL,
  `email_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pro_emails`
--

INSERT INTO `pro_emails` (`id`, `sender`, `receivers`, `ccs`, `subject`, `text`, `email_time`) VALUES
(1, 'kasra', 0x0402000e00000003000700830067657474657231676574746572322d6e6173746f6f682d6b696d6961, 0x0402000e00000003000700830067657474657231676574746572322d6e6173746f6f682d6b696d6961, 'habool', 'babool', '2020-06-12 22:35:48'),
(2, 'qwerty', 0x040300150000000300070073000e00e3006765747465723167657474657232676574746572332d7177657274792d6f706c6f33342d717765727479333639, 0x0403000900000003000300a300060023016363316363326363332d6b61737261323032342d706f706f3132332d717765727479383532, 'dead', 'popo is dead', '2020-06-12 22:59:55'),
(3, 'qwerty', 0x040300150000000300070073000e00e3006765747465723167657474657232676574746572332d7177657274792d7177657274792d717765727479333639, 0x0403000900000003000300a300060023016363316363326363332d6b61737261323032342d706f706f3132332d717765727479383532, 'dead', 'popo is dead', '2020-06-12 23:04:33'),
(5, 'qwerty', 0x0403001500000003000700a3000e0043016765747465723167657474657232676574746572332d6b61737261323032342d6b61737261323032342d717765727479333639, 0x0403000900000003000300a300060023016363316363326363332d6b61737261323032342d706f706f3132332d717765727479383532, 'dead', 'popo is dead', '2020-06-12 23:16:27'),
(6, 'qwerty', 0x0403001500000003000700a3000e0043016765747465723167657474657232676574746572332d6b61737261323032342d6b61737261323032342d6b6173726132303234, 0x0403000900000003000300a300060043016363316363326363332d6b61737261323032342d6b61737261323032342d6b6173726132303234, 'pooooooooooo', 'mmad is dead', '2020-06-12 23:31:15'),
(7, 'qwerty', 0x040300150000000300070073000e0013016765747465723167657474657232676574746572332d7177657274792d6b61737261323032342d717765727479333639, 0x0403000900000003000300a300060023016363316363326363332d6b61737261323032342d706f706f3132332d717765727479383532, 'dead', 'popo is dead', '2020-06-12 23:50:08'),
(8, 'nicolas', 0x0403001500000003000700a3000e0023016765747465723167657474657232676574746572332d6b61737261323032342d6e69636f6c61732d6a61636b313233, 0x040300090000000300030083000600f3006363316363326363332d6e69636f6c61732d6f706c6f33342d717765727479, 'jico is dead', 'he was killed like a dog', '2020-06-13 15:54:14'),
(9, 'nicolas', 0x040300150000000300070073000e0013016765747465723167657474657232676574746572332d7177657274792d6b61737261323032342d717765727479333639, 0x0403000900000003000300a300060023016363316363326363332d6b61737261323032342d706f706f3132332d717765727479383532, 'dead', 'popo is dead', '2020-06-13 16:15:48'),
(10, 'qwerty', 0x040300150000000300070013000e0083006765747465723167657474657232676574746572332d2d6f706c6f33342d717765727479333639, 0x0403000900000003000300a300060023016363316363326363332d6b61737261323032342d706f706f3132332d717765727479383532, 'dead', 'popo is dead', '2020-06-13 23:29:31'),
(11, 'qwerty', 0x040300150000000300070013000e0023006765747465723167657474657232676574746572332d2d2d, 0x04030009000000030003001300060023006363316363326363332d2d2d, 'dead', 'popo is dead', '2020-06-13 23:35:05'),
(12, 'qwerty', 0x040300150000000300070073000e0083006765747465723167657474657232676574746572332d6f706c6f33342d2d, 0x0403000900000003000300a300060023016363316363326363332d6b61737261323032342d706f706f3132332d, 'fire', 'paris is on fire', '2020-06-13 23:36:21'),
(13, 'qwerty', 0x040300150000000300070083000e0093006765747465723167657474657232676574746572332d6e69636f6c61732d2d, 0x04030009000000030003007300060083006363316363326363332d7177657274792d2d, 'kipo has been shot', 'kipo is dead', '2020-06-14 19:10:46');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` varchar(25) NOT NULL,
  `fname` varchar(25) NOT NULL,
  `lname` varchar(25) NOT NULL,
  `phone` varchar(25) NOT NULL,
  `birthday` date NOT NULL,
  `nickname` varchar(25) NOT NULL,
  `pitt_id` varchar(25) NOT NULL,
  `password` varchar(100) NOT NULL,
  `address` varchar(25) NOT NULL,
  `date_created` datetime NOT NULL
) ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `fname`, `lname`, `phone`, `birthday`, `nickname`, `pitt_id`, `password`, `address`, `date_created`) VALUES
('******', '***', '***', '***', '2020-01-01', '***', '***', '***', '***', '2020-06-09 17:45:20'),
('234567', '23', '23', '23', '2020-05-20', '23', '23', '37693cfc748049e45d87b8c7d8b9aacd', '23', '2020-05-27 12:11:39'),
('asdfasdf', 'sadfasdsdfg', 'asdfasd', 'afsdf', '2020-02-02', 'sadf', 'asdf', '6a204bd89f3c8348afd5c77c717a097a', 'asdf', '2020-06-13 22:52:38'),
('jack123', 'jack', 'rice', '00123', '1998-02-02', 'jackiii', '002', '1d6c1e168e362bc0092f247399003a88', 'new york', '2020-06-13 15:34:35'),
('jojosaqsaq', 'gt', 'gt', 'gt', '2020-05-20', 'gt', 'gt', '81dc9bdb52d04dc20036dbd8313ed055', 'gt', '2020-05-27 14:19:07'),
('kasra2024', 'kasra', 'mojallal', '0938', '2020-05-08', 'kasii', '002', '81dc9bdb52d04dc20036dbd8313ed055', 'nyc', '2020-05-27 14:07:25'),
('kolikoli123', 'asdf', 'dsaf', 'asdf', '2020-02-02', 'asdf', 'sdfdsf', '3ac9245f5558408bb3c24bf2ec8a78b9', 'sdaf', '2020-06-13 22:51:56'),
('kolkol90', 'asdf', 'asdf', '894132', '2020-02-02', 'asdfds', 'sadfsd', '134c703ff7e9a244684198a5bc9b87cc', 'asdffd', '2020-06-13 23:18:06'),
('nicolas', 'nico', 'las', '0912', '2020-06-06', 'nikiiii', '0032', 'deb97a759ee7b8ba42e02dddf2b412fe', 'colalampoor', '2020-06-13 15:36:09'),
('niloo12', 'asdf', 'sdf', 'sdfsdf', '0000-00-00', 'sdfa', 'asdf', '81dc9bdb52d04dc20036dbd8313ed055', 'df', '2020-05-28 16:23:07'),
('oplo34', 'opolojoon', '1', 'asdfgsd', '0000-00-00', '1', '1', '81dc9bdb52d04dc20036dbd8313ed055', '1', '2020-05-27 12:31:07'),
('popo123', 'loli', 'piko', '0912', '2020-02-02', 'kasd', '002', '81dc9bdb52d04dc20036dbd8313ed055', 'asdkf', '2020-06-09 17:41:45'),
('qwerty', 'kasra', 'lolpo', 'asdfgsd', '2020-05-08', 'vrt', '005', 'e10adc3949ba59abbe56e057f20f883e', 'los', '2020-05-27 02:34:01'),
('qwerty369', 'loli', 'piko', '0912', '2020-02-02', 'kasd', '002', 'c20ad4d76fe97759aa27a0c99bff6710', 'asdkf', '2020-06-09 17:43:38'),
('qwerty852', 'loli', 'piko', '0912', '2020-02-02', 'kasd', '002', 'c20ad4d76fe97759aa27a0c99bff6710', 'asdkf', '2020-06-09 17:45:20');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `sign_up_news` AFTER INSERT ON `users` FOR EACH ROW begin
    insert into news(owner, text, news_time) values(NEW.id, 'you have signed up', NOW());
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_on_user_info` AFTER UPDATE ON `users` FOR EACH ROW begin
    insert into news(owner, text, news_time) values(NEW.id, 'you changed your info', NOW());
end
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `pro_emails`
--
ALTER TABLE `pro_emails`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `pro_emails`
--
ALTER TABLE `pro_emails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
