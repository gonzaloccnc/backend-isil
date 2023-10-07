package pe.isil.app.domain.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import pe.isil.app.domain.enums.Rol;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Entity(name = "courses") @Data @Builder @AllArgsConstructor @NoArgsConstructor
public class Course {
  @Id
  private String idCourse;

  private String courseName;
  private int credits;
  private String description;
  private String syllabus;


}
