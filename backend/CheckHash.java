import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class CheckHash {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        System.out.println("Matches: " + encoder.matches("irsyad1805", "$2b$12$sodvCtH9RfnoXg2Q5Spd4uBx4Cts9ev1BIUyvAg1X6GqTAWJrmrnW"));
        System.out.println("New Hash: " + encoder.encode("irsyad1805"));
    }
}
