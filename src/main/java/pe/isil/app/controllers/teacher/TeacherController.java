package pe.isil.app.controllers.teacher;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;

@RestController
@RequestMapping("/teacher")
@RequiredArgsConstructor
public class TeacherController {

  @GetMapping("/get")
  ResponseEntity<?> greeting() {
    var map = new HashMap<String, String>();
    map.put("message", "hello world security teacher");
    return ResponseEntity.ok(map);
  }
}
