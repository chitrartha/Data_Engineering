with open("test.txt", 'w') as f:
    e = 1

    #Hour data
    hr = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23']
    counter = 0
    h = hr[0]

    #Year will e 1889-2019
    for y in range(1889, 2019):

        #Month
        for m in range(1, 12):
            day_counter = 0

            #Day
            for d in range(1, 31):

                #Randomize repition of particular day etweenn 12-100.
                for day_count in range(1, random.randint(12, 100)):
                        if len(str(m)) == 1 and  len(str(d)) == 1:
                            mon = '0' + str(m) #Padding '0' for sigle digit month
                            day = '0' + str(d) #Padding '0' for sigle digit day
                            res = '"timestamp":"' + str(y) + '-' + mon + '-' + day
                        elif len(str(d)) != 1 and len(str(m)) == 1:
                            mon = '0' + str(m)
                            res = '"timestamp"' + str(y) + '-'  + mon + '-' + str(d)
                        elif len(str(d)) == 1 and len(str(m)) != 1:
                            day = '0' + str(d)
                            res = '"timestamp":"' + str(y) + '-'  + str(m) + '-' + day
                        else:
                            res = '"timestamp":"' + str(y) + '-' + str(m) + '-' + str(d)


                        u = random.randint(1, 10) #Randomize user.
                        url = random.randint(1, 5) #Randomize url.
                        f.write('{"eventId":"e' + str(e) + '", ' + res + 'T' + str(h) + ':00:00Z"' + ', "userId":"u' + str(u) + '", "url":"http://site.com/' + str(url) + '"}\n')
                        if e %random.randint(16, 100) == 0: #Randomize repition of particular Hour as per event_id % random int.
                            if counter == len(hr)-1: #Hour reaches to 23 thhe set to 0.
                                counter = 0
                                h = hr[counter]
                            else:
                                counter += 1 #Increase hour from hr list y 1
                                h = hr[counter]
                        e = e + 1 #Each event will be unique in inncreasing order.
