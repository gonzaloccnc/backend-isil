package pe.isil.app.controllers.course;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.isil.app.domain.dtos.ErrorDto;
import pe.isil.app.domain.models.Course;
import pe.isil.app.domain.models.User;
import pe.isil.app.domain.repos.ICourseRepo;

import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/admin/course")
@RequiredArgsConstructor
public class CourseController {

    private final ICourseRepo courseService;

    @PostMapping("/create")
    public ResponseEntity<?> createCourse(@RequestBody Course course) {
        var admin = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (course.getCourseName() == null || course.getCourseName().trim().isEmpty()) {
            return ResponseEntity.status(400).body(ErrorDto.builder().message("El nombre del curso es obligatorio.").build());
        }

        course.setIdCourse(String.valueOf(UUID.randomUUID()));
        course.setUserCreation(admin.getIdUser());

        Course createdCourse = courseService.save(course);

        return ResponseEntity.status(201).body(createdCourse);
    }

    @PutMapping("/update/{courseId}")
    public ResponseEntity<Object> updateCourse(@RequestBody Course updatedCourse, @PathVariable("courseId") String courseId) {
        var admin = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Course courseFromDB = courseService.findById(courseId).orElse(null);

        if (courseFromDB == null) {
            return ResponseEntity.status(404).body(ErrorDto.builder().message("Curso no encontrado con el ID: " + courseId).build());
        }

        // Validar el número de créditos
        int credits = updatedCourse.getCredits();
        if (credits < 2 || credits > 4) {
            return ResponseEntity.status(400).body(ErrorDto.builder().message("El número de créditos debe estar entre 2 y 4.").build());
        }

        // Validar el nombre del curso
        String courseName = updatedCourse.getCourseName();
        if (courseName == null || courseName.trim().isEmpty()) {
            return ResponseEntity.status(400).body(ErrorDto.builder().message("El nombre del curso no puede estar vacío o ser nulo.").build());
        }

        // Actualizar el curso si pasa las validaciones
        courseFromDB.setCourseName(updatedCourse.getCourseName());
        courseFromDB.setDescription(updatedCourse.getDescription());
        courseFromDB.setCredits(updatedCourse.getCredits());
        courseFromDB.setSyllabus(updatedCourse.getSyllabus());
        courseFromDB.setUserUpdating(admin.getIdUser());
        // Guardar el curso actualizado en la base de datos
        Course updatedCourseInDB = courseService.save(courseFromDB);

        return ResponseEntity.ok(updatedCourseInDB);
    }

    @DeleteMapping("/delete/{courseId}")
    public ResponseEntity<Object> deleteCourse(@PathVariable("courseId") String courseId) {
        // Verificar si el courseId es válido o existe en la base de datos
        Optional<Course> courseOptional = courseService.findById(courseId);

        if (!courseOptional.isPresent()) {
            return ResponseEntity.status(404).body(ErrorDto.builder().message("Curso no encontrado con el ID: " + courseId).build());
        }

        // El courseId es válido, eliminar el curso
        courseService.deleteById(courseId);

        return ResponseEntity.ok().build();
    }
}
