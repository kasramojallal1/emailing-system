-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Jun 12, 2020 at 02:26 PM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `block_user` (IN `username` VARCHAR(25), IN `blocked_user` VARCHAR(25))  BEGIN
    insert into block(owner, b_user) values (username, blocked_user);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_email` (IN `sender` VARCHAR(25), IN `receiver` VARCHAR(25), IN `cc` VARCHAR(25), IN `if_read` VARCHAR(25), IN `subject` VARCHAR(25), IN `text` VARCHAR(100))  BEGIN
    insert into emails(sender, receiver, cc, if_read, subject, text, email_time)
    values (sender, receiver,cc, if_read, subject, text, now());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_news` (IN `owner` VARCHAR(25), IN `text` VARCHAR(100))  BEGIN
    insert into news(owner, text, news_time) values (owner, text, now());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_rec_email` (IN `username` VARCHAR(25), IN `in_subject` VARCHAR(25))  BEGIN
    UPDATE emails SET receiver = '***' WHERE receiver = username and subject = in_subject;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_sent_email` (IN `username` VARCHAR(25), IN `in_subject` VARCHAR(25))  BEGIN
    UPDATE emails SET sender = '***' WHERE sender = username and subject = in_subject;
 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_user` (IN `username` VARCHAR(25))  BEGIN
    delete from users where id = username;
    delete from news where owner = username;
    delete from emails where receiver = username;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_info` ()  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    select * from users where id = def_user;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_news` ()  BEGIN
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    select text from news where owner = def_user order by news_time desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_one_rec_email` (IN `username` VARCHAR(25), IN `subj` VARCHAR(25))  BEGIN
    select text from emails where receiver = username and subject = subj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_one_sent_email` (IN `username` VARCHAR(25), IN `subj` VARCHAR(25))  BEGIN
    select text from emails where sender = username and subject = subj;
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
            select * from users where id = username;
        end;
    else
        begin
            select * from users where id = '******';
        end;
    end if;
        end;
    else
        begin
            select 'there is no such user';
        end;
    end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rec_emails` (IN `username` VARCHAR(25), IN `page_start` INT, IN `page_end` INT)  BEGIN
    select subject, text, if_read from emails where receiver = username order by email_time desc limit page_start, page_end;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_sent_emails` (IN `username` VARCHAR(25), IN `page_start` INT, IN `page_end` INT)  BEGIN
    select subject, text, if_read from emails where sender = username order by email_time desc limit page_start, page_end;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `loli` (IN `arg1` VARCHAR(25))  begin
    declare getter10 varchar(25);
    set getter10 = arg1;
    set getter10 = replace(getter10, '@foofle.com','');
    select getter10;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_create_email` (IN `getter1` VARCHAR(25), IN `getter2` VARCHAR(25), IN `getter3` VARCHAR(25), IN `cc1` VARCHAR(25), IN `cc2` VARCHAR(25), IN `cc3` VARCHAR(25), IN `text1` VARCHAR(25), IN `subject1` VARCHAR(25))  begin
    declare def_user varchar(25);
    select last_user into def_user from entries order by date_entered desc LIMIT 1;
    if(getter1 = '')
    then
        begin
        end;
    else
        begin
            declare getter10 varchar(25);
            set getter10 = getter1;
            set getter10 = replace(getter10, '@foofle.com','');
            if exists(select * from users where id = getter10)
            then
                begin
                    call create_email(def_user, getter10, '0','0',subject1, text1);
                end;
            else
                begin
                    select 'account 1 is incorrect';
                end;
            end if;
        end;
    end if;
    if(getter2 = '')
    then
        begin
        end;
    else
        begin
            declare getter20 varchar(25);
            set getter20 = getter2;
            set getter20 = replace(getter20, '@foofle.com','');
            if exists(select * from users where id = getter20)
            then
                begin
                    call create_email(def_user, getter20, '0','0',subject1, text1);
                end;
            else
                begin
                    select 'account 2 is incorrect';
                end;
            end if;
        end;
    end if;
    if(getter3 = '')
    then
        begin
        end;
    else
        begin
            declare getter30 varchar(25);
            set getter30 = getter3;
            set getter30 = replace(getter30, '@foofle.com','');
            if exists(select * from users where id = getter30)
            then
                begin
                    call create_email(def_user, getter30, '0','0',subject1, text1);
                end;
            else
                begin
                    select 'account 3 is incorrect';
                end;
            end if;
        end;
    end if;
    if(cc1 = '')
    then
        begin
        end;
    else
        begin
            declare cc10 varchar(25);
            set cc10 = cc1;
            set cc10 = replace(cc10, '@foofle.com','');
            if exists(select * from users where id = cc10)
            then
                begin
                    call create_email(def_user, cc10, '1','0',subject1, text1);
                end;
            else
                begin
                    select 'cc 1 is incorrect';
                end;
            end if;
        end;
    end if;
    if(cc2 = '')
    then
        begin
        end;
    else
        begin
            declare cc20 varchar(25);
            set cc20 = cc2;
            set cc20 = replace(cc20, '@foofle.com','');
            if exists(select * from users where id = cc20)
            then
                begin
                    call create_email(def_user, cc20, '1','0',subject1, text1);
                end;
            else
                begin
                    select 'cc 2 is incorrect';
                end;
            end if;
        end;
    end if;
    if(cc3 = '')
    then
        begin
        end;
    else
        begin
            declare cc30 varchar(25);
            set cc30 = cc3;
            set cc30 = replace(cc30, '@foofle.com','');
            if exists(select * from users where id = cc30)
            then
                begin
                    call create_email(def_user, cc30, '1','0',subject1, text1);
                end;
            else
                begin
                    select 'cc 3 is incorrect';
                end;
            end if;
        end;
    end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_create_user` (IN `id` VARCHAR(25), IN `fname` VARCHAR(25), IN `lname` VARCHAR(25), IN `phone` VARCHAR(25), IN `birthday` VARCHAR(25), IN `nickname` VARCHAR(25), IN `pitt_id` VARCHAR(25), IN `password` VARCHAR(25), IN `address` VARCHAR(25))  begin
    if not exists(select id from users where users.id = id)
    then
        begin
            if id not like '%[^0-9a-z]%' and id like '______%'
            then
                begin
                    if password not like '%[^0-9a-z]%' and password like '______%'
                    then
                        begin
                            insert into users(id, fname, lname, phone, birthday, nickname, pitt_id, password, address, date_created)
                            values (id, fname,lname, phone, birthday, nickname, pitt_id, MD5(password), address, now());
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_rec_email` (IN `username` VARCHAR(25), IN `email_subject` VARCHAR(25))  BEGIN
    update emails set if_read = '1' where receiver = username and subject = email_subject;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_sent_email` (IN `username` VARCHAR(25), IN `email_subject` VARCHAR(25))  BEGIN
        update emails set if_read = '1' where sender = username and subject = email_subject;
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
('as', 'df'),
('df', 'km'),
('df', 'km'),
('qwerty', '12'),
('oplo34', 'qwerty');

-- --------------------------------------------------------

--
-- Table structure for table `emails`
--

CREATE TABLE `emails` (
  `sender` varchar(25) NOT NULL,
  `receiver` varchar(25) NOT NULL,
  `cc` varchar(10) NOT NULL,
  `if_read` varchar(10) NOT NULL,
  `subject` varchar(25) DEFAULT NULL,
  `text` varchar(100) DEFAULT NULL,
  `email_time` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `emails`
--

INSERT INTO `emails` (`sender`, `receiver`, `cc`, `if_read`, `subject`, `text`, `email_time`) VALUES
('8', '8', '1', '2', '0', 'po', '2020-05-27 01:32:21'),
('1', '1', 'b', 'u', 'ro', 'po', '2020-05-27 01:33:14'),
('12', '23', '0', '0', 'gp', 'lo', '2020-05-27 12:32:28'),
('as', 'df', '0', '0', 'sub', 'text', '2020-05-29 01:11:28'),
('as', 'df', '0', '0', 'sub', 'text', '2020-05-29 01:17:44'),
('as', 'df', '0', '0', 'sub', 'text', '2020-05-29 01:18:33'),
('qwerty', 'poko', '0', '0', 'asd', 'dfddfg', '2020-05-29 01:28:41'),
('asd', 'df', 'df', 'fasd', 'gf', 'gf', '2020-05-27 01:32:21'),
('qwerty', 'oplo34', '0', '1', 'asdfa', 'gdfgfd', '2020-05-29 02:21:43'),
('qwerty', 'oplo34', '0', '1', 'asdf', 'asdf', '2020-05-29 02:23:54'),
('***', 'oplo34', '0', '1', 'poripetere', 'asdf', '2020-05-29 02:50:09'),
('***', '***', '0', '1', 'opoy', 'asdf', '2020-05-29 02:51:48'),
('oplo34', '***', '0', '1', 'asdf', 'dfgsfhg', '2020-05-29 02:51:48'),
('oplo34', 'qwerty', '0', '1', 'dfugksdhg', 'sdfjkh', '2020-05-29 02:51:48'),
('qwerty', 'arqavan', '0', '0', 'os-projects', 'projects have been graded', '2020-06-11 11:50:43'),
('qwerty', 'kasra', '1', '0', 'os-projects', 'projects have been graded', '2020-06-11 11:50:43'),
('qwerty', 'nastooh', '1', '0', 'os-projects', 'projects have been graded', '2020-06-11 11:50:43'),
('qwerty', 'kasra2024', '0', '0', 'os-projects', 'projects have been graded', '2020-06-11 13:50:05'),
('qwerty', 'kasra2024', '0', '0', 'os-projects', 'projects have been graded', '2020-06-11 14:41:27'),
('qwerty', 'qwerty', '0', '0', 'os-projects', 'adsf', '2020-06-11 14:45:06'),
('qwerty', 'qwerty', '0', '0', 'os-projects', 'adsf', '2020-06-11 14:45:11'),
('qwerty', 'qwerty', '0', '0', 'os-cts', 'habool', '2020-06-11 15:07:19'),
('qwerty', 'qwerty', '0', '0', 'os-cts', 'habool', '2020-06-11 15:08:14'),
('qwerty', 'kasra2024', '1', '0', 'os-cts', 'habool', '2020-06-11 15:08:14'),
('qwerty', 'oplo34', '1', '0', 'os-cts', 'habool', '2020-06-11 15:08:14');

--
-- Triggers `emails`
--
DELIMITER $$
CREATE TRIGGER `email_trigger` AFTER INSERT ON `emails` FOR EACH ROW begin
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
('koli', '2020-05-28 14:25:44'),
('qwerty', '2020-05-29 02:27:01'),
('qwerty', '2020-05-29 02:28:52'),
('qwerty', '2020-05-29 02:29:47'),
('qwerty', '2020-05-29 02:31:01'),
('qwerty', '2020-05-29 02:49:52'),
('qwerty', '2020-06-09 14:16:43'),
('qwerty', '2020-06-09 14:31:25'),
('qwerty', '2020-06-09 23:12:55'),
('qwerty', '2020-06-09 23:13:43'),
('oplo34', '2020-06-09 23:14:43'),
('qwerty', '2020-06-10 00:15:45'),
('qwerty', '2020-06-10 00:27:27'),
('qwerty', '2020-06-10 00:29:34'),
('qwerty', '2020-06-10 00:43:45'),
('qwerty', '2020-06-10 01:06:27'),
('qwerty', '2020-06-10 01:14:52'),
('qwerty', '2020-06-10 01:15:18'),
('qwerty', '2020-06-10 22:35:23'),
('qwerty', '2020-06-10 22:44:11'),
('qwerty', '2020-06-10 23:07:04'),
('qwerty', '2020-06-10 23:07:50'),
('qwerty', '2020-06-10 23:12:31'),
('qwerty', '2020-06-11 11:58:59');

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
('5', '6', '2020-05-27 00:36:44'),
('6', '4', '2020-05-27 01:14:41'),
('234567890', 'you have signed up', '2020-05-27 02:12:08'),
('qwerty', 'you have signed up', '2020-05-27 02:22:58'),
('qwerty', 'you have signed up', '2020-05-27 02:34:01'),
('as', 'sd', '2020-05-27 12:32:57'),
('as', 'adf', '2020-05-27 12:48:02'),
('asdf', 'lolilp', '2020-05-27 20:14:24'),
('aadfasf', 'lolilp', '2020-05-28 13:58:35'),
('as', 'asdfasd', '2020-05-28 16:20:57'),
('niloo12', 'you have signed up', '2020-05-28 16:23:07'),
('qwerty', 'you have logged in', '2020-05-28 16:24:28'),
('qwerty', 'you have logged in', '2020-05-28 17:08:06'),
('qwerty', 'you have logged in', '2020-05-28 17:09:47'),
('niloo12', 'qwertywanted to access your info', '2020-05-28 17:20:53'),
('qwerty', 'you have logged in', '2020-05-28 17:23:54'),
('oplo34', 'qwerty wanted to access your info and was blocked', '2020-05-28 17:23:59'),
('234567', 'qwerty wanted to access your info and was granted access', '2020-05-28 17:24:06'),
('qwerty', 'you changed your info', '2020-05-28 17:26:29'),
('qwerty', 'you changed your info', '2020-05-28 17:28:19'),
('qwerty', 'you have logged in', '2020-05-29 01:13:21'),
('qwerty', 'you have logged in', '2020-05-29 01:15:05'),
('qwerty', 'you have logged in', '2020-05-29 01:15:51'),
('qwerty', 'you have logged in', '2020-05-29 01:19:02'),
('qwerty', 'you have logged in', '2020-05-29 01:20:29'),
('qwerty', 'you have logged in', '2020-05-29 01:20:51'),
('qwerty', 'you have logged in', '2020-05-29 01:22:18'),
('qwerty', 'you have logged in', '2020-05-29 01:27:06'),
('qwerty', 'you have logged in', '2020-05-29 01:28:27'),
('qwerty', 'you have logged in', '2020-05-29 01:31:09'),
('qwerty', 'you have logged in', '2020-05-29 01:39:38'),
('qwerty', 'qwerty wanted to access your info and was granted access', '2020-05-29 01:39:44'),
('oplo34', 'qwerty wanted to access your info and was blocked', '2020-05-29 01:39:50'),
('qwerty', 'you have logged in', '2020-05-29 01:41:31'),
('qwerty', 'you have logged in', '2020-05-29 01:42:43'),
('qwerty', 'you have logged in', '2020-05-29 01:44:50'),
('qwerty', 'you have logged in', '2020-05-29 01:48:21'),
('qwerty', 'you have logged in', '2020-05-29 01:49:38'),
('qwerty', 'you have logged in', '2020-05-29 01:50:38'),
('qwerty', 'you have logged in', '2020-05-29 01:51:57'),
('qwerty', 'you have logged in', '2020-05-29 01:53:41'),
('qwerty', 'you have logged in', '2020-05-29 01:54:51'),
('qwerty', 'you have logged in', '2020-05-29 01:57:52'),
('qwerty', 'you have logged in', '2020-05-29 01:58:44'),
('df', 'you have a new email', '2020-05-29 02:20:22'),
('qwerty', 'you have logged in', '2020-05-29 02:21:33'),
('oplo34', 'you have a new email', '2020-05-29 02:21:43'),
('', 'you have a new email', '2020-05-29 02:21:44'),
('qwerty', 'you have logged in', '2020-05-29 02:23:47'),
('oplo34', 'you have a new email', '2020-05-29 02:23:54'),
('', 'you have a new email', '2020-05-29 02:23:54'),
('qwerty', 'you have logged in', '2020-05-29 02:25:04'),
('qwerty', 'you have logged in', '2020-05-29 02:25:55'),
('oplo34', 'you have a new email', '2020-05-29 02:26:31'),
('qwerty', 'you have logged in', '2020-05-29 02:27:01'),
('kasra2024', 'you have a new email', '2020-05-29 02:27:16'),
('oplo34', 'you have a new email', '2020-05-29 02:27:16'),
('', 'you have a new email', '2020-05-29 02:27:16'),
('kasra2024', 'you have a new email', '2020-05-29 02:27:43'),
('oplo34', 'you have a new email', '2020-05-29 02:27:43'),
('234567', 'you have a new email', '2020-05-29 02:27:43'),
('qwerty', 'you have logged in', '2020-05-29 02:28:52'),
('oplo34', 'you have a new email', '2020-05-29 02:28:57'),
('', 'you have a new email', '2020-05-29 02:28:57'),
('oplo34', 'you have a new email', '2020-05-29 02:29:05'),
('', 'you have a new email', '2020-05-29 02:29:05'),
('qwerty', 'you have logged in', '2020-05-29 02:29:47'),
('', 'you have a new email', '2020-05-29 02:29:54'),
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
('12', 'you have signed up', '2020-06-09 23:03:30'),
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
('oplo34', 'you have a new email', '2020-06-11 15:08:14');

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
('jojosaqsaq', 'gt', 'gt', 'gt', '2020-05-20', 'gt', 'gt', '81dc9bdb52d04dc20036dbd8313ed055', 'gt', '2020-05-27 14:19:07'),
('kasra2024', 'kasra', 'mojallal', '0938', '2020-05-08', 'kasii', '002', '81dc9bdb52d04dc20036dbd8313ed055', 'nyc', '2020-05-27 14:07:25'),
('niloo12', 'asdf', 'sdf', 'sdfsdf', '0000-00-00', 'sdfa', 'asdf', '81dc9bdb52d04dc20036dbd8313ed055', 'df', '2020-05-28 16:23:07'),
('oplo34', 'opolojoon', '1', 'asdfgsd', '0000-00-00', '1', '1', '81dc9bdb52d04dc20036dbd8313ed055', '1', '2020-05-27 12:31:07'),
('popo123', 'loli', 'piko', '0912', '2020-02-02', 'kasd', '002', '81dc9bdb52d04dc20036dbd8313ed055', 'asdkf', '2020-06-09 17:41:45'),
('qwerty', 'kolkol', 'lolpo', 'asdfgsd', '2020-05-08', 'vrt', '005', 'e10adc3949ba59abbe56e057f20f883e', 'los', '2020-05-27 02:34:01'),
('qwerty369', 'loli', 'piko', '0912', '2020-02-02', 'kasd', '002', 'c20ad4d76fe97759aa27a0c99bff6710', 'asdkf', '2020-06-09 17:43:38'),
('qwerty852', 'loli', 'piko', '0912', '2020-02-02', 'kasd', '002', 'c20ad4d76fe97759aa27a0c99bff6710', 'asdkf', '2020-06-09 17:45:20');

--
-- Triggers `users`
--
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
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
