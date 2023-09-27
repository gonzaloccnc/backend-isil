package pe.isil.app.services;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Service;
import pe.isil.app.domain.models.User;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Service
public class JwtService {

    private final static String SECRET = "f5615154dce6b07dca31884158f0d1dab26b5ea3d3c94754f4d67118ee529a56";
    private final static Long ACCESS_TOKEN_SECONDS = 1_296_000L;

    public String extractUsername(String token) {
        return extractClaims(token, Claims::getSubject);
    }

    public <T> T extractClaims(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    public boolean isTokenValid(String token, User userDetails) {
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername())) && !isTokenExpired(token);
    }

    public String generateToken(User userDetails) {
        return generateTokenBuilder(new HashMap<>(), userDetails);
    }

    private String generateTokenBuilder(Map<String, Object> extraClaims, User userDetails) {
        long expirationTime = ACCESS_TOKEN_SECONDS * 1000;
        Date expirationDate = new Date(System.currentTimeMillis() + expirationTime);

        extraClaims.put("role", getRole(userDetails.getUserType()));
        extraClaims.put("firstname", userDetails.getFirstname());
        extraClaims.put("surnames", userDetails.getSurnames());
        extraClaims.put("email", userDetails.getEmail());
        extraClaims.put("photo", userDetails.getPhoto());
        extraClaims.put("id", userDetails.getIdUser());

        return Jwts.builder()
                .setClaims(extraClaims)
                .setSubject(userDetails.getUsername())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(expirationDate)
                .signWith(Keys.hmacShaKeyFor(SECRET.getBytes()), SignatureAlgorithm.HS256)
                .compact();
    }

    private boolean isTokenExpired(String token) {
        return extraExpiration(token).before(new Date());
    }

    private Date extraExpiration(String token) {
        return extractClaims(token, Claims::getExpiration);
    }

    public Claims extractAllClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(SECRET.getBytes())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private String getRole(int state) {
      return switch (state) {
        case 1 -> "ADMIN";
        case 2 -> "PROFESOR";
        case 3 -> "ALUMNO";
        default -> "NULL";
      };
    }

}
