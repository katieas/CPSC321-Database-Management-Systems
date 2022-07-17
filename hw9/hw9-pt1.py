
import mysql.connector
import config

def main():
    try: 
        # connection info
        usr = config.mysql['user']
        pwd = config.mysql['password']
        hst = config.mysql['host']
        dab = 'kstevens3_DB'
        # create a connection
        con = mysql.connector.connect(user=usr,password=pwd, host=hst,
                                      database=dab)
        rs = con.cursor()
        
        

        exitMenu = False
        while not exitMenu:
            print('1. List countries\n2. Add country\n3. Find countries based on gdp and inflation\n4. Update country\'s gdp and inflation\n5. Exit')
            user_input = raw_input('Enter your choice (1-5): ')

            if user_input == "1":
                # list countries
                query = ''' SELECT country_name, country_code
                            FROM Country'''
                rs.execute(query)
                for (name, code) in rs:
                    print ('{} ({})'.format(name, code))
                print ('\n')

            elif user_input == "2":
                # add country
                code = raw_input('Country code................: ')
                name = raw_input('Country name................: ')
                cgdp = raw_input('Country per capita gdp (USD): ')
                cinf = raw_input('Country inflation (pct).....: ')

                # check if country code does not exist
                query = '''SELECT EXISTS(
                                SELECT *
                                FROM Country
                                WHERE country_code = %s)'''
                rs.execute(query, (code,))
                result = rs.fetchall()
                if result[0][0] == 0:
                    # query is empty, country does not exist in database yet
                    insert = 'INSERT INTO Country(country_code, country_name, gdp, inflation) VALUES (%s, %s, %s, %s)'
                    rs.execute(insert, (code, name, cgdp, cinf))
                    con.commit()
                else: 
                    # country does exist
                    print ('Country already exists')
    
            elif user_input == "3":
                # find countries based on gdp and inflation
                numc = raw_input('Number of countries to display: ')
                min_gdp = raw_input('Minimum per capita gdp (USD)..: ')
                max_inf = raw_input('Maximum inflation (pct).......: ')

                # ERROR SOMEWHERE HERE I GUESS
                query = '''SELECT country_code, country_name, gdp, inflation
                           FROM Country
                           WHERE gdp >= %s AND %s >= inflation
                           ORDER BY gdp DESC, inflation ASC
                           LIMIT %s'''
                rs.execute(query, (int(min_gdp), int(max_inf), int(numc)))
                for (code, name, gdp, inflation) in rs:
                    print ('{} ({}), {}, {}'.format(name, code, gdp, inflation))

            elif user_input == "4": 
                # update countries
                code = raw_input('Country code................: ')
                cgdp = raw_input('Country per capita gdp (USD): ')
                cinf = raw_input('Country inflation (pct).....: ')

                # check if country code exists
                query = '''SELECT EXISTS(
                                SELECT *
                                FROM Country
                                WHERE country_code = %s)'''
                rs.execute(query, (code,))
                result = rs.fetchall()
                if result[0][0] == 1:
                    update = 'UPDATE Country SET gdp = %s, inflation = %s WHERE country_code = %s'
                    rs.execute(update, (cgdp, cinf, code))
                    con.commit()
                else:
                    print("The country entered does not exist in the database")

            elif user_input == "5":
                # exit
                exitMenu = True

        rs.close()
        con.close()
            
    except mysql.connector.Error as err:
        print err


if __name__ == '__main__':
    main()
    
