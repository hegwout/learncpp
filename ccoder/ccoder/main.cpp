//
//  main.cpp
//  ccoder
//
//  Created by hegw on 16/4/26.
//  Copyright © 2016年 hegw. All rights reserved.
//

#include <iostream>
#include <sstream>
#include <memory>
#include <string>
#include <stdexcept>

using namespace std;


#include <mysql_connection.h>
#include <mysql_driver.h>
#include <cppconn/driver.h>

#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>

#define EXAMPLE_HOST "localhost"
#define EXAMPLE_USER "root"
#define EXAMPLE_PASS "mysql"
#define EXAMPLE_DB "oro_abi"

int main(int argc, const char * argv[]) {
    string url(argc >= 2 ? argv[1] : EXAMPLE_HOST);
    const string user(argc >= 3 ? argv[2] : EXAMPLE_USER);
    const string pass(argc >= 4 ? argv[3] : EXAMPLE_PASS);
    const string database(argc >= 5 ? argv[4] : EXAMPLE_DB);
    
    cout << endl;
    cout << "Connector/C++ standalone program example..." << endl;
    cout << endl;
    
    try {
        sql::Driver * driver = sql::mysql::get_driver_instance();
        /* Using the Driver to create a connection */
        boost::scoped_ptr< sql::Connection > con(driver->connect(url, user, pass));
        con->setSchema(database);
        
        boost::scoped_ptr< sql::Statement > stmt(con->createStatement());
        boost::scoped_ptr< sql::ResultSet > res(stmt->executeQuery("SELECT 'Welcome to Connector/C++' AS _message"));
        cout << "\t... running 'SELECT 'Welcome to Connector/C++' AS _message'" << endl;
        while (res->next()) {
            cout << "\t... MySQL replies: " << res->getString("_message") << endl;
            cout << "\t... say it again, MySQL" << endl;
            cout << "\t....MySQL replies: " << res->getString(1) << endl;
        }
        
    } catch (sql::SQLException &e) {
        /*
         The MySQL Connector/C++ throws three different exceptions:
         
         - sql::MethodNotImplementedException (derived from sql::SQLException)
         - sql::InvalidArgumentException (derived from sql::SQLException)
         - sql::SQLException (derived from std::runtime_error)
         */
        cout << "# ERR: SQLException in " << __FILE__;
       // cout << "(" << EXAMPLE_FUNCTION << ") on line " << __LINE__ << endl;
        /* Use what() (derived from std::runtime_error) to fetch the error message */
        cout << "# ERR: " << e.what();
        cout << " (MySQL error code: " << e.getErrorCode();
        cout << ", SQLState: " << e.getSQLState() << " )" << endl;
        
        return EXIT_FAILURE;
    }
    
    cout << endl;
    cout << "... find more at http://www.mysql.com" << endl;
    cout << endl;
    return EXIT_SUCCESS;
}
