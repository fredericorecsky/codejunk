
using System;
using System.IO;
using System.Net;
using System.Web;

namespace PedacodeMoeda 
{
    public class Biotonico
    {
        public float euros 
        {
            get;
            set;
        }
        public DateTime date 
        {
            get { return date; }
            set 
            {
                if ( value != null ) {
                    date = value;
                } else {
                    date = DateTime.Today;
                }
            }
        }
        public Biotonico ()
        {
        }

        //public HttpResponse GetPrice () 
        public string GetPrice () 
        {
            WebRequest request = WebRequest.Create( "http://www.frederico.me" );
            request.Credentials = CredentialCache.DefaultCredentials;

            HttpWebResponse response = (HttpWebResponse)request.GetResponse();

            Console.WriteLine( response.StatusDescription );

            Stream dataStream = response.GetResponseStream();

            StreamReader reader = new StreamReader( dataStream );

            string responseFromServer = reader.ReadToEnd();

            Console.WriteLine( responseFromServer );

            reader.Close();
            dataStream.Close();
            response.Close();

            return responseFromServer;
        }

        public Stream GetPriceStream ()
        {
            WebRequest request = WebRequest.Create( "http://www.frederico.me" );
            request.Credentials = CredentialCache.DefaultCredentials;

            HttpWebResponse response = (HttpWebResponse)request.GetResponse();

            Console.WriteLine( response.StatusDescription );

            Stream dataStream = response.GetResponseStream();

            return dataStream;

        }

    }
}
