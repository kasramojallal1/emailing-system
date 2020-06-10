def create_procedures(cursor):
    cursor.execute('''create table if not exists users
                            (id             varchar(25) not null,
                            fname           varchar(25) not null,
                            lname           varchar(25) not null,
                            phone           varchar(25) not null,
                            birthday        date not null,
                            nickname        varchar(25) not null,
                            pitt_id         varchar(25) not null,
                            password        varchar(100) not null,
                            address         varchar(25) not null,
                            date_created    datetime not null,
                            primary key (id),
                            check ( CHAR_LENGTH(id) >= 6 )
                            );''')

    cursor.execute('''create table if not exists news
                    (owner          varchar(25) not null,
                    text            varchar(100),
                    news_time       datetime not null
                    );''')

    cursor.execute('''create table if not exists emails(
                    sender          varchar(25) not null,
                    receiver        varchar(25) not null,
                    cc              varchar(10) not null,
                    if_read         varchar(10) not null,
                    subject         varchar(25),
                    text            varchar(100),
                    email_time      datetime not null
                    );''')

    cursor.execute('''create table if not exists entries(
                    last_user          varchar(25) not null,
                    date_entered       datetime not null
                    );''')

    cursor.execute('''create table if not exists block(
                    owner          varchar(25) not null,
                    b_user          varchar(25) not null
                    );''')

    cursor.execute('''DROP procedure IF EXISTS get_one_sent_email;''')

    cursor.execute('''create
    definer = root@localhost procedure get_one_sent_email(IN username varchar(25), IN subj varchar(25))
BEGIN
    select text from emails where sender = username and subject = subj;
END;''')




    cursor.execute('''DROP procedure IF EXISTS get_one_rec_email;''')

    cursor.execute('''create
    definer = root@localhost procedure get_one_rec_email(IN username varchar(25), IN subj varchar(25))
BEGIN
    select text from emails where receiver = username and subject = subj;
END;''')




    cursor.execute('''DROP procedure IF EXISTS get_rec_emails;''')

    cursor.execute('''create
    definer = root@localhost procedure get_rec_emails(IN username varchar(25), IN page_start INT, IN page_end INT)
BEGIN
    select subject, text, if_read from emails where receiver = username order by email_time desc limit page_start, page_end;
END;''')




    cursor.execute('''DROP procedure IF EXISTS get_sent_emails;''')

    cursor.execute('''create
    definer = root@localhost procedure get_sent_emails(IN username varchar(25), IN page_start INT, IN page_end INT)
BEGIN
    select subject, text, if_read from emails where sender = username order by email_time desc limit page_start, page_end;
END;''')



    cursor.execute('''DROP procedure IF EXISTS delete_sent_email;''')

    cursor.execute('''create
    definer = root@localhost procedure delete_sent_email(IN username varchar(25), IN in_subject varchar(25))
BEGIN
    UPDATE emails SET sender = '***' WHERE sender = username and subject = in_subject;
 END;''')




    cursor.execute('''DROP procedure IF EXISTS delete_rec_email;''')

    cursor.execute('''create
    definer = root@localhost procedure delete_rec_email(IN username varchar(25), IN in_subject varchar(25))
BEGIN
    UPDATE emails SET receiver = '***' WHERE receiver = username and subject = in_subject;
 END;''')




    cursor.execute('''DROP procedure IF EXISTS read_rec_email;''')

    cursor.execute('''create
    definer = root@localhost procedure read_rec_email(IN username varchar(25), IN email_subject varchar(25))
BEGIN
    update emails set if_read = '1' where receiver = username and subject = email_subject;
END;''')

    cursor.execute('''DROP procedure IF EXISTS read_sent_email;''')

    cursor.execute('''create
    definer = root@localhost procedure read_sent_email(IN username varchar(25), IN email_subject varchar(25))
BEGIN
        update emails set if_read = '1' where sender = username and subject = email_subject;
    END;''')



    cursor.execute('''DROP trigger IF EXISTS email_trigger;''')

    cursor.execute('''create trigger email_trigger
    after insert
    on emails
    for each row
begin
    insert into news(owner, text, news_time) values(NEW.receiver, 'you have a new email', NOW());
end;''')



    cursor.execute('''DROP trigger IF EXISTS update_on_user_info;''')

    cursor.execute('''create trigger update_on_user_info
    after update
    on users
    for each row
begin
    insert into news(owner, text, news_time) values(NEW.id, 'you changed your info', NOW());
end;''')




    cursor.execute('''DROP trigger IF EXISTS login_news;''')

    cursor.execute('''create trigger login_news
    after insert
    on entries
    for each row
begin
    insert into news(owner, text, news_time) values(NEW.last_user, 'you have logged in', NOW());
end;''')



    cursor.execute('''DROP PROCEDURE IF EXISTS check_blocked;''')

    cursor.execute('''create
    definer = root@localhost procedure check_blocked(IN username varchar(25), IN des_user varchar(25) ,OUT yes_no int)
BEGIN
    select count(*) into yes_no from block where owner = des_user and b_user = username;
END;''')



    cursor.execute('''DROP PROCEDURE IF EXISTS create_entry;''')

    cursor.execute('''create
    definer = root@localhost procedure create_entry(IN username varchar(25))
BEGIN
    insert into entries(last_user, date_entered) values (username, now());
END;''')




    cursor.execute('''DROP PROCEDURE IF EXISTS block_user;''')

    cursor.execute('''create
    definer = root@localhost procedure block_user(IN username varchar(25), IN blocked_user varchar(25))
BEGIN
    insert into block(owner, b_user) values (username, blocked_user);
END;''')




    cursor.execute('''DROP PROCEDURE IF EXISTS delete_user;''')

    cursor.execute('''create
    definer = root@localhost procedure delete_user(IN username varchar(25))
BEGIN
    delete from users where id = username;
    delete from news where owner = username;
    delete from emails where receiver = username;
END;''')



    cursor.execute('''DROP PROCEDURE IF EXISTS create_news;''')

    cursor.execute('''create
    definer = root@localhost procedure create_news(IN owner varchar(25), IN text varchar(100))
BEGIN
    insert into news(owner, text, news_time) values (owner, text, now());
END;''')



    cursor.execute('''DROP PROCEDURE IF EXISTS create_email;''')

    cursor.execute('''create
    definer = root@localhost procedure create_email(IN sender varchar(25), IN receiver varchar(25), IN cc varchar(25), IN if_read varchar(25)
    , IN subject varchar(25), IN text varchar(100))
BEGIN
    insert into emails(sender, receiver, cc, if_read, subject, text, email_time)
    values (sender, receiver,cc, if_read, subject, text, now());
END;''')
