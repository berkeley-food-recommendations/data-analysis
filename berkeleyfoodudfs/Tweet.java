package berkeleyfoodudfs;

import java.util.List;
import com.google.gson.annotations.SerializedName;

public class Tweet {
    @SerializedName("id_str")
    public String idStr;
    public Coordinates coordinates;
    static class Coordinates {
        public double[] coordinates;
        public String type;
        public Coordinates() {
            // no-args constructor
        }
    }
    public String text;
    public String source;
    static class Geo {
        public double[] coordinates;
        public String type;
        public Geo() {
            // no-args constructor
        }
    }
    private static class EntityCollection {
        public int[] indices;
        public EntityCollection() {
        }
    }
    static class URL extends EntityCollection {
        public String url;
        public String displayUrl;
        public String expandedUrl;
        public URL() {
        }
    }
    static class Hashtag extends EntityCollection {
        public Hashtag() {
        }
    }
    static class Entities {
        List<URL> urls;
        List<Hashtag> hashtags;
        List<User> userMentions;
        public Entities() {
        }
    }

    static class User extends EntityCollection {
        public String idStr;

        public String url;
        public int followersCount;
        public String profileImageUrl;
        public int listedCount;
        public String timeZone;
        public String profileTextColor;
        public String profileBackgroundImageUrl;
        public int friendsCount;
        public String description;
        public String location;
        public String profileLinkColor;
        public int statusesCount;
        public String profileBackgroundColor;
        public String profileBackgroundTile;
        public String profileImageUrlHttps;
        public String lang;
        public Boolean verified;
        public String profileSidebarFillColor;
        public String name;
        public String geoEnabled;
        public String favouritesCount;
        public String screenName;
        public String utcOffset;
        public String createdAt;
        public String profileSidebarBorderColor;

        public User() {
        }
    }

    public String createdAt;

    public Tweet() {
        // no-args constructor
    }
}
