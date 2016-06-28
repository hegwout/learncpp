//
//  main.cpp
//  ccoder
//
//  Created by hegw on 16/4/26.
//  Copyright © 2016年 hegw. All rights reserved
//
//  NEED:
//      boost_1_60_0
//      mysql-connector-c++-1.1.7
//      https://github.com/OlafvdSpek/ctemplate
//      https://github.com/jbeder/yaml-cpp/
//

#include <iostream>
#include <fstream>
#include <sstream>
#include <memory>
#include <string>
#include <map>
#include <stdexcept>

using namespace std;


#include <mysql_connection.h>
#include <mysql_driver.h>
#include <cppconn/driver.h>

#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <boost/date_time.hpp>

#include <yaml-cpp/yaml.h>
#include <ctemplate/template.h>


void GenerateEntity(boost::scoped_ptr< sql::Connection >& con);
std::string YAMLParse( const std::string& name);
std::string TypeToEntityType(const std::string &type){
    string entityType ;
    if( type.find_first_of('(') > 0 ){
        entityType = type.substr(0,type.find_first_of('('));
    }
    else
        entityType = type;
    map<string,string> mapType;
    mapType.insert(pair<string,string>("tinyint"       , "boolean"));
    mapType.insert(pair<string,string>("smallint"      , "smallint"));
    mapType.insert(pair<string,string>("mediumint"     , "integer"));
    mapType.insert(pair<string,string>("int"           , "integer"));
    mapType.insert(pair<string,string>("integer"       , "integer"));
    mapType.insert(pair<string,string>("bigint"        , "bigint"));
    mapType.insert(pair<string,string>("tinytext"      , "text"));
    mapType.insert(pair<string,string>("mediumtext"    , "text"));
    mapType.insert(pair<string,string>("longtext"      , "text"));
    mapType.insert(pair<string,string>("text"          , "text"));
    mapType.insert(pair<string,string>("varchar"       , "string"));
    mapType.insert(pair<string,string>("string"        , "string"));
    mapType.insert(pair<string,string>("char"          , "string"));
    mapType.insert(pair<string,string>("date"          , "date"));
    mapType.insert(pair<string,string>("datetime"      , "datetime"));
    mapType.insert(pair<string,string>("timestamp"     , "datetime"));
    mapType.insert(pair<string,string>("time"          , "time"));
    mapType.insert(pair<string,string>("float"         , "float"));
    mapType.insert(pair<string,string>("double"        , "float"));
    mapType.insert(pair<string,string>("real"          , "float"));
    mapType.insert(pair<string,string>("decimal"       , "decimal"));
    mapType.insert(pair<string,string>("numeric"       , "decimal"));
    mapType.insert(pair<string,string>("year"          , "date"));
    mapType.insert(pair<string,string>("longblob"      , "blob"));
    mapType.insert(pair<string,string>("blob"          , "blob"));
    mapType.insert(pair<string,string>("mediumblob"    , "blob"));
    mapType.insert(pair<string,string>("tinyblob"      , "blob"));
    mapType.insert(pair<string,string>("binary"        , "blob"));
    mapType.insert(pair<string,string>("varbinary"     , "blob"));
    mapType.insert(pair<string,string>("set"           , "simple_array"));
    map<string,string>::iterator it = mapType.find(entityType);
    if( it != mapType.end() )
        return it->second;
    throw "There is no map type: " + type;
}

std::string FieldToEntityField(const std::string &field){
    string entityField;
    size_t i , next = 0;
    for( i = 0 ; i < field.length(); i++ ){
        if( field[i] == '_' ){
            next = i + 1;
            continue;
        }
        if( i > 0 && next == i )
            entityField += toupper(field[i]);
        else
            entityField+= field[i];
    }
    return entityField;
}

int main(int argc, const char * argv[]) {
    
    try {
        sql::Driver * driver = sql::mysql::get_driver_instance();
        boost::scoped_ptr< sql::Connection > con(driver->connect(YAMLParse("db_host"), YAMLParse("db_user"), YAMLParse("db_pass")));
        con->setSchema(YAMLParse("db_name"));
        GenerateEntity(con);
        
        
        
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
    cout << "DONE" << endl;
    cout << endl;
    return EXIT_SUCCESS;
}
void GenerateEntity(boost::scoped_ptr< sql::Connection > &con){
    
    boost::scoped_ptr< sql::Statement > stmt(con->createStatement());
    boost::scoped_ptr< sql::ResultSet > res(stmt->executeQuery("SHOW FULL COLUMNS FROM " + YAMLParse("table_name") ));
    ctemplate::TemplateDictionary dictionary("entity");
    
    while (res->next()) {
        ctemplate::TemplateDictionary *result_dictionary = dictionary.AddSectionDictionary("ONE_RESULT");
        result_dictionary->ShowSection("FIELD_SECTION");
        string field = res->getString("Field") ;
        string entityFieldType = TypeToEntityType(res->getString("Type")) ;
        if( "YES" == res->getString("Null") )
            result_dictionary->ShowSection("FieldNullSection");
        result_dictionary->SetValue("Field", field);
        result_dictionary->SetValue("EntityFieldType", entityFieldType);
        string entityField(FieldToEntityField(field)) ;
        result_dictionary->SetValue("EntityField", entityField);
        string fieldMethodName (entityField);
        fieldMethodName[0] = toupper(fieldMethodName[0]);
        result_dictionary->SetValue("FieldMethodName", fieldMethodName);
        string key(res->getString("Key"));
        if( key == "PRI" )
            result_dictionary->ShowSection("FieldPrimarySection");
    }
    string entity(YAMLParse("entity"));
    string bundle(YAMLParse("bundle"));
    string tableName(YAMLParse("table_name"));
    dictionary.SetValue("TableName", tableName);
    dictionary.SetValue("Bundle", bundle);
    dictionary.SetValue("Entity", entity);
    std::string output;
    ctemplate::ExpandTemplate("entity.tpl", ctemplate::DO_NOT_STRIP, &dictionary, &output);
    
    ofstream out(entity + ".php");
    if( out.is_open() ){
        out << output;
        out.close();
    }

    
}

std::string YAMLParse( const std::string& name){
    try{
        static YAML::Node config = YAML::LoadFile("config.yaml");
        return config[name].as<std::string>();
    }
    catch(exception ee){
        return "";
    }
}
