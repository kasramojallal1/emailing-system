from PyQt5.QtWidgets import QApplication
from DB import functions

import mysql.connector

from GUI import windows
import sys


def whole(cursor, conn):

    app = QApplication(sys.argv)
    ex = windows.main_window(cursor, conn)
    sys.exit(app.exec_())

    # try:
    # except mysql.connector.Error as err:
    #     print("problem: {}".format(err))

    # args = ()
    # cursor.callproc('get_info', args)
    #
    # string = ''
    #
    # for result in cursor.stored_results():
    #     string =result.fetchall()
    #
    # string = str(string).replace("(", '')
    # string = str(string).replace(")", '')
    # # string = str(string).replace("'", '')
    # string = str(string).replace("[", '')
    # string = str(string).replace("]", '')
    # string = str(string).replace("datetime.date", '')
    # string = str(string).replace("datetime.datetime", '')
    # #
    # string = str(string).split(", ")
    # #
    # for i in range(len(string)):
    #     string[i] = str(string[i]).replace("'", '')
    #
    # print(string)



    return 0
