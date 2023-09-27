package pe.isil.app.controllers.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.isil.app.services.JwtService;

import java.util.HashMap;

@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

  private final JwtService jwtService;

  @GetMapping("/get")
  ResponseEntity<?> greeting(HttpServletRequest req) {
    /*
    var bearer = req.getHeader("Authorization");
    var token = bearer.replace("Bearer ", "");

    var claims = jwtService.extractAllClaims(token);
    var role = claims.get("role");

    if(role.equals("ADMIN")) {
      var map = new HashMap<String, String>();
      map.put("message", "hello world security ADMIN");
      return ResponseEntity.ok(map);
    }
*/
    var map = new HashMap<String, String>();
    map.put("message", "hello world security admin");
    return ResponseEntity.ok(map);
  }
}
