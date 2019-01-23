using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TwitterSentimentAnaylisis.Models.Dashboard
{
    public class TweetViewModel
    {
        public string TweetContent { get; set; }
        public string TweetDate { get; set; }
        public string TweetScore { get; set; }
    }
}
