
using System;
using System.IO;
using System.Collections.Generic;

namespace TagsParser
{

    public class Tag
    {
        public string name { get; set; }
        public string content { get; set; }
        public long   start { get; set; }
        public long   end  { get; set; }

        public Tag( long position)
        {
            start = position;
        }

    }

    public class Parser 
    {
        private Stream stream { get; set; }
        private StreamReader reader { get; set ; }
        private Tag document { get; set; }

        private List<Tag> tags = new List<Tag>();

        public Parser ( Stream value )
        {
            stream = value;
            Tag document = new Tag( 0 );
        }

        public void Parse() 
        {
            reader = new StreamReader( stream );
            long position = 0;

            while( reader.Peek() > -1 ) 
            {
                char actual = (char) reader.Read();

                if ( actual == '<' ) {
                    Tag newtag = new Tag( position );
                    tag.children( newtag ); 
                    tag = newtag;
                }else{
                    tag.process( actual );
                }

                position++;
            }
        }

        public void process ( char actual, long position ) 
        {
        }

        public delegate content( char actual , long position )
        {
        }

        public delegate CloseTag( char actual , long position )
        {
            phase = "content";
        }

        public delegate EndTag( char actual, long position )
        {
            end = position;
        }
        
    }
}
