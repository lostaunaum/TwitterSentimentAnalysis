using System;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using TwitterSentimentAnaylisis.Models;

[assembly: HostingStartup(typeof(TwitterSentimentAnaylisis.Areas.Identity.IdentityHostingStartup))]
namespace TwitterSentimentAnaylisis.Areas.Identity
{
    public class IdentityHostingStartup : IHostingStartup
    {
        public void Configure(IWebHostBuilder builder)
        {
            builder.ConfigureServices((context, services) => {
                services.AddDbContext<TwitterSentimentAnaylisisContext>(options =>
                    options.UseSqlServer(
                        context.Configuration.GetConnectionString("TwitterSentimentAnaylisisContextConnection")));

                //services.AddDefaultIdentity<IdentityUser>()
                //    .AddEntityFrameworkStores<TwitterSentimentAnaylisisContext>();
            });
        }
    }
}