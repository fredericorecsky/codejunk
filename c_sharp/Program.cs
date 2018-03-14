using System;
using System.IO;
//using TagsParser;

namespace PedacodeMoeda
{
    class Program
    {
        static void Main(string[] args)
        {
            string path = null;

            if ( args.Length > 0 ) {
                path = args[0];
            }

            Stream stream = (Stream) File.Open( path, FileMode.Open ); 

            Parser parse = new Parser( stream );
            
            /*
            StreamReader reader = new StreamReader( stream );

            string final = reader.ReadToEnd();

            Console.Write( final );
            */
        }
    }
}
