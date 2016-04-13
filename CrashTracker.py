
import web
import MySQLdb
import datetime
import time

db = web.database(dbn='mysql', user='root', pw='qwer1234', db='crash_tracker')
urls = (
    '/report/(.+)', 'report',
    '/catch', 'catch'
)


class report:
    def GET(self, params):
        query_statement = 'select * from crash_log'
        where = ';'
        isLegal = True
        if params != 'all':
            condition = params.split('/')
            if len(condition) == 2:
                if condition[0] == 'timestamp':
                    where = " where Timestamp = '" + condition[1] + "' "  + where
                elif condition[0] == 'username':
                    where = " where Username = '" + condition[1] + "' "  + where
                elif condition[0] == 'userobjectid':
                    where = " where UserObjectId = '" + condition[1] + "' "  + where
                else:
                    isLegal = False
                    where = 'Illegal Key: ' + condition[0] + '\nLegal Keys: timestamp, username, userobjectid'
            else:
                isLegal = False
                where = 'Illegal parameter form, expected parameter form: /condition/key'
            if isLegal == False:
                return where
        
        query_statement = query_statement + where
        print 'query_statement: ' + query_statement 
        crash_report = '|Timestamp\t\t|Username\t|UserObjectOd\t|Cause\n' 
        entries = db.query(query_statement)
        if len(entries) == 0:
            crash_report = 'no record(s) found'
        else:
            for entry in entries:
                entry_content = '|' + entry.Timestamp + '\t|' + entry.Username + '\t\t|' + entry.UserObjectId + '\t|' + entry.Cause + '\n'
                crash_report = crash_report + entry_content
        return crash_report

    
class catch:
    def POST(self):
        data = web.data().split('&')
        username = data[0][9:]
        user_object_id = data[1][13:]
        cause = data[2][6:]
        time_formatted = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d %H:%M:%S')
        db.insert('crash_log', Timestamp=time_formatted, Username=username, UserObjectId=user_object_id, Cause=cause)


if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()
