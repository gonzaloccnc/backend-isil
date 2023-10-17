package pe.isil.app.domain.repos;

import pe.isil.app.domain.models.CourseView;
import pe.isil.app.domain.models.DetailClass;

import java.util.List;

public interface ICourseDetailRepo extends IReadOnlyRepo <CourseView ,String>{
    List<CourseView> findAllByIdStudent(String idStudent);

}
