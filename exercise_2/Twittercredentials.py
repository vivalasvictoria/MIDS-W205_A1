import tweepy

consumer_key = "Xwyo58h2AENSpVRKMXwzAGAA4";
#eg: consumer_key = "YisfFjiodKtojtUvW4MSEcPm";


consumer_secret = "62lhIGtY6ffYQMjtFO5UQAXBuvdgKv0dC9KaXMJB0bHUFdx5lE";
#eg: consumer_secret = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";

access_token = "343711606-1MQsOZuGfffIUovOSMC5377FRAZI8zK6BCD0mWBI";
#eg: access_token = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";

access_token_secret = "gKLbEQXIrWoZndpgBKjDWNgq6gReHAZgHMNc4VD5I2nfz";
#eg: access_token_secret = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";


auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)



