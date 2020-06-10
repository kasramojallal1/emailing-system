from DB import functions
import states

if __name__ == "__main__":

    cursor, conn = functions.connect_to_db()
    # functions.init_db(cursor)

    states.whole(cursor, conn)
