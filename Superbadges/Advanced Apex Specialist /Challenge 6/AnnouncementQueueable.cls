/*
 * By: Alonso Ortiz - 08/Mar/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_aap
 *
 * Challenge 6: Automate internal announcements when inventory is low
 */

/**
 * @name AnnouncementQueueable
 * @description This class posts Chatter Announcements
**/
public class AnnouncementQueueable {

    public List<ConnectApi.AnnouncementInput> toPost;

    //ToDo: Modify this class to implement the Queueable interface and call the postAnnouncements method
    public class QueueablePostAnnouncements implements Queueable { 
		
        private AnnouncementQueueable announcement;
        
        public QueueablePostAnnouncements(AnnouncementQueueable announcement) { 
            this.announcement = announcement;
        }
        
        public void execute(QueueableContext context) {
            PostAnnouncements(announcement.toPost);
        }
    }


    /**
     * @name postAnnouncements
     * @description This method is provided for you to facilitate the Super Badge
    **/
    public static void PostAnnouncements(List<ConnectApi.AnnouncementInput> announcements){
        while ( announcements.size() > 0 ){
            if ( Limits.getDMLStatements() < Limits.getLimitDMLStatements() && !test.isRunningTest() ){
                ConnectApi.AnnouncementInput a = announcements.remove(0);
                ConnectApi.Announcements.postAnnouncement('Internal', a);
            } else {
                break;
            }
        }
        if ( announcements.size() > 0 && !test.isRunningTest() ){
            AnnouncementQueueable q = new AnnouncementQueueable();
            q.toPost = announcements;

            //ToDo: Enqueue the above instance of announcementQueueable
            System.enqueueJob(new QueueablePostAnnouncements(q));
        }
    }

}