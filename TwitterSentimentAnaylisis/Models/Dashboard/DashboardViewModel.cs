using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TwitterSentimentAnaylisis.Models.Dashboard
{
    public class DashboardViewModel
    {
        public string TwitterUserFirstName { get; set; }
        public string TwitterUserLastName { get; set; }
        public string TwitterUserName { get; set; }
        public string TwitterUserPhoto { get; set; }
        public TweetViewModel Tweets { get; set; }
    }
}
