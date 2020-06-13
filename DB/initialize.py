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
