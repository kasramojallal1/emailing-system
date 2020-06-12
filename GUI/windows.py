from PyQt5.QtCore import *
from PyQt5.QtWidgets import *

from DB import functions

import mysql.connector


class main_window(QMainWindow):
    def __init__(self, cursor, conn):
        super().__init__()
        self.title = "App"
        self.top = 700
        self.left = 400
        self.width = 450
        self.height = 300
        self.cursor = cursor
        self.conn = conn
        self.InitUI()

    def InitUI(self):
        self.setWindowTitle(self.title)
        self.setGeometry(self.top, self.left, self.width, self.height)

        signup_button = QPushButton('signup', self)
        signup_button.move(100, 100)
        signup_button.clicked.connect(self.buttonWindow1_onClick)

        login_button = QPushButton('login', self)
        login_button.move(250, 100)
        login_button.clicked.connect(self.buttonWindow2_onClick)
        self.show()

    @pyqtSlot()
    def buttonWindow1_onClick(self):
        self.cams = signup_window(self.cursor, self.conn)
        self.cams.show()
        self.close()

    @pyqtSlot()
    def buttonWindow2_onClick(self):
        self.cams = login_window(self.cursor, self.conn)
        self.cams.show()
        self.close()


class signup_window(QDialog):
    def __init__(self, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('signup')

        self.cursor = cursor
        self.conn = conn

        label_username = QLabel('username:')
        self.box_username = QLineEdit()
        label_password = QLabel('password:')
        self.box_password = QLineEdit()
        label_fname = QLabel('first name:')
        self.box_fname = QLineEdit()
        label_lname = QLabel('last name:')
        self.box_lname = QLineEdit()
        label_phone = QLabel('phone:')
        self.box_phone = QLineEdit()
        label_birthday = QLabel('birthday:')
        self.box_birthday = QLineEdit()
        label_nickname = QLabel('nickname:')
        self.box_nickname = QLineEdit()
        label_pitt = QLabel('pitt id:')
        self.box_pitt = QLineEdit()
        label_address = QLabel('address:')
        self.box_address = QLineEdit()

        signup_button = QPushButton('Sign Up')
        signup_button.clicked.connect(self.signup_clicked)

        layoutV = QVBoxLayout()

        layoutV.addWidget(label_username)
        layoutV.addWidget(self.box_username)
        layoutV.addWidget(label_password)
        layoutV.addWidget(self.box_password)
        layoutV.addWidget(label_fname)
        layoutV.addWidget(self.box_fname)
        layoutV.addWidget(label_lname)
        layoutV.addWidget(self.box_lname)
        layoutV.addWidget(label_phone)
        layoutV.addWidget(self.box_phone)
        layoutV.addWidget(label_birthday)
        layoutV.addWidget(self.box_birthday)
        layoutV.addWidget(label_nickname)
        layoutV.addWidget(self.box_nickname)
        layoutV.addWidget(label_pitt)
        layoutV.addWidget(self.box_pitt)
        layoutV.addWidget(label_address)
        layoutV.addWidget(self.box_address)

        layoutV.addWidget(signup_button)

        self.setLayout(layoutV)

    def signup_clicked(self):
        args = (self.box_username.text(), self.box_fname.text(), self.box_lname.text()
                , self.box_phone.text(), self.box_birthday.text(), self.box_nickname.text()
                , self.box_pitt.text(), self.box_password.text(), self.box_address.text())
        self.cursor.callproc('pro_create_user', args)

        for result in self.cursor.stored_results():
            print(result.fetchall())

        self.conn.commit()

        arguments = (self.box_username.text(), 'you have signed up')
        self.cursor.callproc('create_news', arguments)
        self.conn.commit()
        self.go_to_login()

    def go_to_login(self):
        self.cams = login_window(self.cursor, self.conn)
        self.cams.show()
        self.close()


class login_window(QDialog):
    def __init__(self, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('login')

        self.cursor = cursor
        self.conn = conn
        self.value = '12'

        label_username = QLabel('username:')
        self.box_username = QLineEdit()
        label_password = QLabel('password:')
        self.box_password = QLineEdit()

        signup_button = QPushButton('Login')
        signup_button.clicked.connect(self.login_clicked)

        layoutV = QVBoxLayout()

        layoutV.addWidget(label_username)
        layoutV.addWidget(self.box_username)
        layoutV.addWidget(label_password)
        layoutV.addWidget(self.box_password)

        layoutV.addWidget(signup_button)

        self.setLayout(layoutV)

    def login_clicked(self):
        args = (self.box_username.text(), self.box_password.text())
        self.cursor.callproc('pro_login', args)
        self.conn.commit()

        string = ''

        for result in self.cursor.stored_results():
            string = result.fetchall()

        print(string)

        if string == '':
            self.value = self.box_username.text()
            self.go_to_desktop()

    def go_to_desktop(self):
        self.cams = desktop_window(self.value, self.cursor, self.conn)
        self.cams.show()
        self.close()


class desktop_window(QDialog):
    def __init__(self, value, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('desktop')

        self.cursor = cursor
        self.conn = conn
        self.username = value

        view_info_button = QPushButton('View Info')
        view_info_button.clicked.connect(self.view_info_clicked)
        view_others_info_button = QPushButton('View Others Info')
        view_others_info_button.clicked.connect(self.view_others_info_clicked)
        edit_info_button = QPushButton('Edit Info')
        edit_info_button.clicked.connect(self.edit_info_clicked)
        get_news_button = QPushButton('News')
        get_news_button.clicked.connect(self.get_news_clicked)
        creat_email_button = QPushButton('Create Email')
        creat_email_button.clicked.connect(self.create_email_clicked)
        check_rec_email_button = QPushButton('Check Emails')
        check_rec_email_button.clicked.connect(self.check_rec_clicked)
        check_sent_email_button = QPushButton('Check Sent Emails')
        check_sent_email_button.clicked.connect(self.check_sent_clicked)
        block_user_button = QPushButton('Block User')
        block_user_button.clicked.connect(self.block_user_clicked)
        delete_account_button = QPushButton('Delete Account')
        delete_account_button.clicked.connect(self.delete_account_clicked)

        layoutV = QVBoxLayout()

        layoutV.addWidget(view_info_button)
        layoutV.addWidget(view_others_info_button)
        layoutV.addWidget(edit_info_button)
        layoutV.addWidget(get_news_button)
        layoutV.addWidget(creat_email_button)
        layoutV.addWidget(check_rec_email_button)
        layoutV.addWidget(check_sent_email_button)
        layoutV.addWidget(block_user_button)
        layoutV.addWidget(delete_account_button)

        self.setLayout(layoutV)

    def view_info_clicked(self):
        self.go_to_info_window()

    def view_others_info_clicked(self):
        self.go_to_view_others_info_window()

    def edit_info_clicked(self):
        self.go_to_edit_window()

    def get_news_clicked(self):
        self.go_to_news_window()

    def create_email_clicked(self):
        self.go_to_create_email_window()

    def check_rec_clicked(self):
        self.go_to_check_rec_email_window()

    def check_sent_clicked(self):
        self.go_to_check_sent_email_window()

    def block_user_clicked(self):
        self.go_to_block_user_window()

    def delete_account_clicked(self):
        args = (self.username,)
        self.cursor.callproc('delete_user', args)
        self.conn.commit()
        self.go_to_login()

    def go_to_info_window(self):
        self.cams = info_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def go_to_view_others_info_window(self):
        self.cams = others_info_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def go_to_edit_window(self):
        self.cams = edit_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def go_to_news_window(self):
        self.cams = news_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def go_to_create_email_window(self):
        self.cams = create_email_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def go_to_check_rec_email_window(self):
        self.cams = set_page_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def go_to_check_sent_email_window(self):
        self.cams = set_page_window_2(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def go_to_block_user_window(self):
        self.cams = block_user_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def go_to_login(self):
        self.cams = login_window(self.cursor, self.conn)
        self.cams.show()
        self.close()


class info_window(QDialog):
    def __init__(self, value, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('my_info')

        self.cursor = cursor
        self.conn = conn
        self.username = value

        args = ()
        cursor.callproc('get_info', args)

        string = ''

        for result in cursor.stored_results():
            string = result.fetchall()

        string = str(string).replace("datetime.datetime", '')
        string = str(string).replace("datetime.date", '')
        string = str(string).replace("(", '')
        string = str(string).replace(")", '')
        string = str(string).replace("'", '')
        string = str(string).replace("[", '')
        string = str(string).replace("]", '')

        string = str(string).split(", ")

        username_label = QLabel('username: ' + string[0])
        fname_label = QLabel('first name:' + string[1])
        lname_label = QLabel('last name:' + string[2])
        phone_label = QLabel('phone:' + string[3])
        birthday_label = QLabel('birthday:' + string[4] + '-' + string[5] + '-' + string[6])
        nickname_label = QLabel('nickname:' + string[7])
        pitt_label = QLabel('pitt:' + string[8])
        address_label = QLabel('address:' + string[10])

        back_button = QPushButton('Back')
        back_button.clicked.connect(self.back_button_clicked)

        layoutV = QVBoxLayout()

        layoutV.addWidget(username_label)
        layoutV.addWidget(fname_label)
        layoutV.addWidget(lname_label)
        layoutV.addWidget(phone_label)
        layoutV.addWidget(birthday_label)
        layoutV.addWidget(nickname_label)
        layoutV.addWidget(pitt_label)
        layoutV.addWidget(address_label)
        layoutV.addWidget(back_button)

        self.setLayout(layoutV)

    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = desktop_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()


class block_user_window(QDialog):

    def __init__(self, value, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('block user')
        self.setWindowIcon(self.style().standardIcon(QStyle.SP_FileDialogInfoView))

        self.cursor = cursor
        self.conn = conn
        self.username = value

        self.box_des_username = QLineEdit()

        block_button = QPushButton('Block')
        block_button.clicked.connect(self.block_clicked)

        back_button = QPushButton('Back')
        back_button.clicked.connect(self.back_button_clicked)

        layoutV = QVBoxLayout()

        layoutV.addWidget(self.box_des_username)
        layoutV.addWidget(block_button)
        layoutV.addWidget(back_button)

        self.setLayout(layoutV)

    def block_clicked(self):
        args = (self.username, self.box_des_username.text())
        self.cursor.callproc('block_user', args)
        self.conn.commit()

    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = desktop_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()


class others_info_window(QDialog):

    def __init__(self, value, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('others info')
        self.setWindowIcon(self.style().standardIcon(QStyle.SP_FileDialogInfoView))

        self.cursor = cursor
        self.conn = conn
        self.username = value
        self.other_username = ''

        self.box_des_username = QLineEdit()

        view_button = QPushButton('View')
        view_button.clicked.connect(self.view_clicked)

        back_button = QPushButton('Back')
        back_button.clicked.connect(self.back_button_clicked)

        layoutV = QVBoxLayout()

        layoutV.addWidget(self.box_des_username)
        layoutV.addWidget(view_button)
        layoutV.addWidget(back_button)

        self.setLayout(layoutV)

    def view_clicked(self):
        self.other_username = self.box_des_username.text()
        self.go_to_view()

    def go_to_view(self):
        self.cams = other_user_info(self.username, self.other_username, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = desktop_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()


class other_user_info(QDialog):
    def __init__(self, value, new_user, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('other user info')
        self.setWindowIcon(self.style().standardIcon(QStyle.SP_FileDialogInfoView))

        self.cursor = cursor
        self.conn = conn
        self.username = value
        self.other_username = new_user
        self.my_string = ''

        args = (self.other_username, )

        cursor.callproc('get_others_info', args)

        string = ''

        for result in cursor.stored_results():
            string = result.fetchall()

        string = str(string).replace("datetime.datetime", '')
        string = str(string).replace("datetime.date", '')
        string = str(string).replace("(", '')
        string = str(string).replace(")", '')
        string = str(string).replace("'", '')
        string = str(string).replace("[", '')
        string = str(string).replace("]", '')

        string = str(string).split(", ")

        if len(string) < 8:

            print(string)

            username_label = QLabel('username: ')
            fname_label = QLabel('first name:')
            lname_label = QLabel('last name:')
            phone_label = QLabel('phone:')
            birthday_label = QLabel('birthday:')
            nickname_label = QLabel('nickname:')
            pitt_label = QLabel('pitt:')
            address_label = QLabel('address:')

            back_button = QPushButton('Back')
            back_button.clicked.connect(self.back_button_clicked)

            layoutV = QVBoxLayout()

            layoutV.addWidget(username_label)
            layoutV.addWidget(fname_label)
            layoutV.addWidget(lname_label)
            layoutV.addWidget(phone_label)
            layoutV.addWidget(birthday_label)
            layoutV.addWidget(nickname_label)
            layoutV.addWidget(pitt_label)
            layoutV.addWidget(address_label)
            layoutV.addWidget(back_button)

            self.setLayout(layoutV)

        else:
            username_label = QLabel('username: ' + string[0])
            fname_label = QLabel('first name:' + string[1])
            lname_label = QLabel('last name:' + string[2])
            phone_label = QLabel('phone:' + string[3])
            birthday_label = QLabel('birthday:' + string[4] + '-' + string[5] + '-' + string[6])
            nickname_label = QLabel('nickname:' + string[7])
            pitt_label = QLabel('pitt:' + string[8])
            address_label = QLabel('address:' + string[10])

            back_button = QPushButton('Back')
            back_button.clicked.connect(self.back_button_clicked)

            layoutV = QVBoxLayout()

            layoutV.addWidget(username_label)
            layoutV.addWidget(fname_label)
            layoutV.addWidget(lname_label)
            layoutV.addWidget(phone_label)
            layoutV.addWidget(birthday_label)
            layoutV.addWidget(nickname_label)
            layoutV.addWidget(pitt_label)
            layoutV.addWidget(address_label)
            layoutV.addWidget(back_button)

            self.setLayout(layoutV)

    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = others_info_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()


class edit_window(QDialog):
    def __init__(self, value, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('edit info')

        self.cursor = cursor
        self.conn = conn
        self.username = value

        label_password = QLabel('password:')
        self.box_password = QLineEdit()
        label_fname = QLabel('first name:')
        self.box_fname = QLineEdit()
        label_lname = QLabel('last name:')
        self.box_lname = QLineEdit()
        label_phone = QLabel('phone:')
        self.box_phone = QLineEdit()
        label_birthday = QLabel('birthday:')
        self.box_birthday = QLineEdit()
        label_nickname = QLabel('nickname:')
        self.box_nickname = QLineEdit()
        label_pitt = QLabel('pitt id:')
        self.box_pitt = QLineEdit()
        label_address = QLabel('address:')
        self.box_address = QLineEdit()

        change_button = QPushButton('Change')
        change_button.clicked.connect(self.change_button_clicked)

        back_button = QPushButton('Back')
        back_button.clicked.connect(self.back_button_clicked)

        layoutV = QVBoxLayout()

        layoutV.addWidget(label_password)
        layoutV.addWidget(self.box_password)
        layoutV.addWidget(label_fname)
        layoutV.addWidget(self.box_fname)
        layoutV.addWidget(label_lname)
        layoutV.addWidget(self.box_lname)
        layoutV.addWidget(label_phone)
        layoutV.addWidget(self.box_phone)
        layoutV.addWidget(label_birthday)
        layoutV.addWidget(self.box_birthday)
        layoutV.addWidget(label_nickname)
        layoutV.addWidget(self.box_nickname)
        layoutV.addWidget(label_pitt)
        layoutV.addWidget(self.box_pitt)
        layoutV.addWidget(label_address)
        layoutV.addWidget(self.box_address)

        layoutV.addWidget(change_button)
        layoutV.addWidget(back_button)

        self.setLayout(layoutV)

    def change_button_clicked(self):
        args = (self.box_fname.text(), self.box_lname.text(), self.box_phone.text(),
                self.box_birthday.text(), self.box_nickname.text(), self.box_pitt.text(),
                self.box_password.text(), self.box_address.text())
        self.cursor.callproc('update_info', args)
        self.conn.commit()

        for result in self.cursor.stored_results():
            print(result.fetchall())

    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = desktop_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()


class news_window(QDialog):
    def __init__(self, value, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('news')

        self.cursor = cursor
        self.conn = conn
        self.username = value

        back_button = QPushButton('Back')
        back_button.clicked.connect(self.back_button_clicked)

        layoutV = QVBoxLayout()

        string = []

        args = ()
        cursor.callproc('get_news', args)

        for result in cursor.stored_results():
            string.append(result.fetchall())

        string = str(string).replace('[', '')
        string = str(string).replace(']', '')
        string = str(string).replace(",)", '')
        string = str(string).replace('(', '')
        string = str(string).replace(')', '')
        string = str(string).replace("'", '')
        string = str(string).replace("'", '')

        string = string.split(',')

        self.list = QListWidget()

        for i in range(len(string)):
            self.list.insertItem(i, string[i])

        layoutV.addWidget(self.list)

        layoutV.addWidget(back_button)

        self.setLayout(layoutV)

    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = desktop_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()


class create_email_window(QDialog):
    def __init__(self, value, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('create email')
        self.setWindowIcon(self.style().standardIcon(QStyle.SP_FileDialogInfoView))

        self.cursor = cursor
        self.conn = conn
        self.username = value
        self.result = '0'

        label_to_who = QLabel('To:')
        self.box_to_who = QLineEdit()
        label_cc = QLabel('cc:')
        self.box_cc = QLineEdit()
        label_subject = QLabel('Subject:')
        self.box_subject = QLineEdit()
        label_text = QLabel('Text:')
        self.box_text = QLineEdit()

        send_button = QPushButton('Send')
        send_button.clicked.connect(self.send_button_clicked)

        back_button = QPushButton('Back')
        back_button.clicked.connect(self.back_button_clicked)

        layoutV = QVBoxLayout()

        layoutV.addWidget(label_to_who)
        layoutV.addWidget(self.box_to_who)
        layoutV.addWidget(label_cc)
        layoutV.addWidget(self.box_cc)
        layoutV.addWidget(label_subject)
        layoutV.addWidget(self.box_subject)
        layoutV.addWidget(label_text)
        layoutV.addWidget(self.box_text)

        layoutV.addWidget(send_button)
        layoutV.addWidget(back_button)

        self.setLayout(layoutV)

    def send_button_clicked(self):

        arr_to_who = self.box_to_who.text()
        arr_to_who = str(arr_to_who).split(',')

        arr_cc = self.box_cc.text()
        arr_cc = str(arr_cc).split(',')

        args = (arr_to_who[0], arr_to_who[1],
                arr_to_who[2], arr_cc[0], arr_cc[1], arr_cc[2],
                self.box_text.text(), self.box_subject.text())

        self.cursor.callproc('pro2_create_email', args)

        self.conn.commit()

        for result in self.cursor.stored_results():
            print(result.fetchall())


    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = desktop_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()


class set_page_window(QDialog):

    def __init__(self, value, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('set page')
        self.setWindowIcon(self.style().standardIcon(QStyle.SP_FileDialogInfoView))

        self.cursor = cursor
        self.conn = conn
        self.username = value
        self.page_number = ''

        self.box_page = QLineEdit()

        view_button = QPushButton('View')
        view_button.clicked.connect(self.view_clicked)

        back_button = QPushButton('Back')
        back_button.clicked.connect(self.back_button_clicked)

        layoutV = QVBoxLayout()

        layoutV.addWidget(self.box_page)
        layoutV.addWidget(view_button)
        layoutV.addWidget(back_button)

        self.setLayout(layoutV)

    def view_clicked(self):
        self.page_number = self.box_page.text()
        self.go_to_view()

    def go_to_view(self):
        self.cams = check_rec_emails_window(self.username, self.page_number, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = desktop_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()


class set_page_window_2(QDialog):

    def __init__(self, value, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('set page')
        self.setWindowIcon(self.style().standardIcon(QStyle.SP_FileDialogInfoView))

        self.cursor = cursor
        self.conn = conn
        self.username = value
        self.page_number = ''

        self.box_page = QLineEdit()

        view_button = QPushButton('View')
        view_button.clicked.connect(self.view_clicked)

        back_button = QPushButton('Back')
        back_button.clicked.connect(self.back_button_clicked)

        layoutV = QVBoxLayout()

        layoutV.addWidget(self.box_page)
        layoutV.addWidget(view_button)
        layoutV.addWidget(back_button)

        self.setLayout(layoutV)

    def view_clicked(self):
        self.page_number = self.box_page.text()
        self.go_to_view()

    def go_to_view(self):
        self.cams = check_sent_emails_window(self.username, self.page_number, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = desktop_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()


class check_rec_emails_window(QDialog):
    def __init__(self, value, page_number, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('check incoming emails')
        self.setWindowIcon(self.style().standardIcon(QStyle.SP_FileDialogInfoView))

        self.cursor = cursor
        self.conn = conn
        self.username = value
        self.page_number = int(page_number)
        self.st = ''
        self.sub = ''

        string = ''

        args = (self.username, self.page_number - 1, self.page_number + 9)
        cursor.callproc('get_rec_emails', args)

        for result in cursor.stored_results():
            string = result.fetchall()

        string = str(string).replace('[', '')
        string = str(string).replace(']', '')
        string = str(string).replace("),", '*')
        string = str(string).replace('(', '')
        string = str(string).replace(')', '')
        string = str(string).replace("'", '')

        string = str(string).split('*')

        result_string = [[] for i in range(len(string))]

        for i in range(len(string)):
            opo = string[i].split(',')
            result_string[i].append(opo[0])
            result_string[i].append(opo[1])
            result_string[i].append(opo[2])

        back_button = QPushButton('Back')
        back_button.clicked.connect(self.back_button_clicked)

        layoutV = QVBoxLayout()

        self.list = QListWidget()
        self.list.clicked.connect(self.list_clicked)

        for i in range(len(result_string)):
            self.list.insertItem(i, 'Subject:' + result_string[i][0] + ',  Read:' + result_string[i][2])

        layoutV.addWidget(self.list)
        layoutV.addWidget(back_button)

        self.setLayout(layoutV)

    def list_clicked(self):
        item = self.list.currentItem()
        self.st = str(item.text())

        self.st = self.st.replace(' ', '')
        self.st = self.st.replace('Subject:', '')
        self.st = self.st.split(',')

        self.sub = self.st[0]

        string = ''
        args = (self.username, self.st[0])

        self.cursor.callproc('get_one_rec_email', args)

        for result in self.cursor.stored_results():
            string = result.fetchall()

        string = str(string).replace('[', '')
        string = str(string).replace(']', '')
        string = str(string).replace(",)", '')
        string = str(string).replace('(', '')
        string = str(string).replace(')', '')
        string = str(string).replace("'", '')
        string = str(string).replace("'", '')

        self.st = string

        self.go_to_email()

    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = desktop_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def go_to_email(self):

        args = (self.username, self.sub)
        self.cursor.callproc('read_rec_email', args)
        self.conn.commit()

        self.cams = email_window(self.st, self.username, self.page_number, self.sub, self.cursor, self.conn)
        self.cams.show()
        self.close()


class check_sent_emails_window(QDialog):
    def __init__(self, value, page_number, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('check incoming emails')
        self.setWindowIcon(self.style().standardIcon(QStyle.SP_FileDialogInfoView))

        self.cursor = cursor
        self.conn = conn
        self.username = value
        self.page_number = int(page_number)
        self.st = ''
        self.sub = ''

        string = ''

        args = (self.username, self.page_number - 1, self.page_number + 9)
        cursor.callproc('get_sent_emails', args)

        for result in cursor.stored_results():
            string = result.fetchall()

        string = str(string).replace('[', '')
        string = str(string).replace(']', '')
        string = str(string).replace("),", '*')
        string = str(string).replace('(', '')
        string = str(string).replace(')', '')
        string = str(string).replace("'", '')

        string = str(string).split('*')

        result_string = [[] for i in range(len(string))]

        for i in range(len(string)):
            opo = string[i].split(',')
            result_string[i].append(opo[0])
            result_string[i].append(opo[1])
            result_string[i].append(opo[2])

        back_button = QPushButton('Back')
        back_button.clicked.connect(self.back_button_clicked)

        layoutV = QVBoxLayout()

        self.list = QListWidget()
        self.list.clicked.connect(self.list_clicked)

        for i in range(len(result_string)):
            self.list.insertItem(i, 'Subject:' + result_string[i][0] + ',  Read:' + result_string[i][2])

        layoutV.addWidget(self.list)
        layoutV.addWidget(back_button)

        self.setLayout(layoutV)

    def list_clicked(self):
        item = self.list.currentItem()
        self.st = str(item.text())

        self.st = self.st.replace(' ', '')
        self.st = self.st.replace('Subject:', '')
        self.st = self.st.split(',')

        self.sub = self.st[0]

        string = ''
        args = (self.username, self.st[0])

        self.cursor.callproc('get_one_sent_email', args)

        for result in self.cursor.stored_results():
            string = result.fetchall()

        string = str(string).replace('[', '')
        string = str(string).replace(']', '')
        string = str(string).replace(",)", '')
        string = str(string).replace('(', '')
        string = str(string).replace(')', '')
        string = str(string).replace("'", '')
        string = str(string).replace("'", '')

        self.st = string

        self.go_to_email_2()

    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = desktop_window(self.username, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def go_to_email_2(self):

        args = (self.username, self.sub)
        self.cursor.callproc('read_sent_email', args)
        self.conn.commit()

        self.cams = email_window_2(self.st, self.username, self.page_number, self.sub, self.cursor, self.conn)
        self.cams.show()
        self.close()


class email_window(QDialog):
    def __init__(self, string, value, page, sub, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('email')
        self.setWindowIcon(self.style().standardIcon(QStyle.SP_FileDialogInfoView))

        self.cursor = cursor
        self.conn = conn
        self.username = value
        self.st = string
        self.page_number = page
        self.sub = sub

        text_label = QLabel('text:\n' + self.st)

        delete_button = QPushButton('Delete')
        delete_button.clicked.connect(self.delete_button_clicked)
        back_button = QPushButton('Back')
        back_button.clicked.connect(self.back_button_clicked)

        layoutV = QVBoxLayout()

        layoutV.addWidget(text_label)
        layoutV.addWidget(delete_button)
        layoutV.addWidget(back_button)

        self.setLayout(layoutV)

    def delete_button_clicked(self):
        args = (self.username, self.sub)
        self.cursor.callproc('delete_rec_email', args)

        self.conn.commit()

        self.delete_the_email()

    def delete_the_email(self):
        self.cams = check_rec_emails_window(self.username, self.page_number, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = check_rec_emails_window(self.username, self.page_number, self.cursor, self.conn)
        self.cams.show()
        self.close()


class email_window_2(QDialog):
    def __init__(self, string, value, page, sub, cursor, conn, parent=None):
        super().__init__(parent)
        self.setWindowTitle('email')
        self.setWindowIcon(self.style().standardIcon(QStyle.SP_FileDialogInfoView))

        self.cursor = cursor
        self.conn = conn
        self.username = value
        self.st = string
        self.page_number = page
        self.sub = sub

        text_label = QLabel('text:\n' + self.st)

        delete_button = QPushButton('Delete')
        delete_button.clicked.connect(self.delete_button_clicked)
        back_button = QPushButton('Back')
        back_button.clicked.connect(self.back_button_clicked)

        layoutV = QVBoxLayout()

        layoutV.addWidget(text_label)
        layoutV.addWidget(delete_button)
        layoutV.addWidget(back_button)

        self.setLayout(layoutV)

    def delete_button_clicked(self):
        args = (self.username, self.sub)
        self.cursor.callproc('delete_sent_email', args)

        self.conn.commit()

        self.delete_the_email()

    def delete_the_email(self):
        self.cams = check_sent_emails_window(self.username, self.page_number, self.cursor, self.conn)
        self.cams.show()
        self.close()

    def back_button_clicked(self):
        self.go_back()

    def go_back(self):
        self.cams = check_sent_emails_window(self.username, self.page_number, self.cursor, self.conn)
        self.cams.show()
        self.close()
