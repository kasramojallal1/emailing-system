from DB import initialize as ini
import mysql.connector


def connect_to_db():
    mydb = mysql.connector.connect(host="localhost", user="root", database="foofle", port='3307')

    cursor = mydb.cursor()

    return cursor, mydb


def init_db(cursor):
    ini.create_procedures(cursor)
