# Emailing System

This project is a mailing system. There is a MariaDB database in which users' data are stored. Users are able to send and receive emails. This database has many procedures (functions), so in order to do a specific task, all there is to do is call that procedure with specific inputs.

The user interface is created by pyQt5. The Python code is mostly the design of the interface and calling the procedures of the database.

## Project Overview

The Emailing System allows users to send and receive emails through an interface designed with pyQt5. User data and emails are stored in a MariaDB database. The system utilizes stored procedures in the database to perform various tasks, ensuring efficient data management and email operations.

## Features

- **User Registration and Authentication**: Users can register and log in to the system. Authentication ensures secure access to user accounts.
- **Send and Receive Emails**: Users can compose, send, and receive emails within the system.
- **Database Management**: The MariaDB database stores user data and emails. Stored procedures handle specific tasks, ensuring efficient database operations.
- **User Interface**: A user-friendly interface created with pyQt5 allows users to interact with the system easily.

## How It Works

1. **Database Setup**: The MariaDB database is set up to store user data and emails. It includes various tables and stored procedures for handling different tasks.

2. **User Interface**: The pyQt5-based interface allows users to register, log in, compose emails, and view received emails.

3. **Stored Procedures**: The system relies on stored procedures in the MariaDB database to perform tasks such as sending emails, retrieving emails, and managing user data. These procedures are called from the Python code.
