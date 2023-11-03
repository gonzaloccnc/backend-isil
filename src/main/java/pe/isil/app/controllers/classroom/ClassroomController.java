package pe.isil.app.controllers.classroom;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.isil.app.domain.dtos.ClassroomDto;
import pe.isil.app.domain.models.DetailClass;
import pe.isil.app.domain.models.MemberClass;
import pe.isil.app.domain.models.StudentGroupsClasses;
import pe.isil.app.domain.repos.IClassDetailRepo;
import pe.isil.app.domain.repos.IClassroomRepo;
import pe.isil.app.domain.repos.IMemberClass;
import pe.isil.app.domain.repos.IStudentGroupsClassRepo;

import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/user/classroom")
@RequiredArgsConstructor
public class ClassroomController {
    private final IClassDetailRepo iClassDetailRepo;
    private final IMemberClass iMemberClass;
    private final IStudentGroupsClassRepo iStudentGroupsClassRepo;

    @GetMapping("/teacher/{idTeacher}")
    public Set<DetailClass> getAllClassrooms(@PathVariable String idTeacher) {
        return iClassDetailRepo.findAllByIdTeacher(idTeacher);
    }

    @GetMapping("/student/{idStudent}")
    public Set<DetailClass> getAllClassroom(@PathVariable String idStudent) {
        return iClassDetailRepo.findAllByIdStudent(idStudent);
    }

    @GetMapping("/members/{idClassroom}")
    public List<MemberClass> getMembers(@PathVariable String idClassroom) {
        return iMemberClass.getMembers(idClassroom);
    }

    @GetMapping("/{idClassroom}/groups")
    public List<StudentGroupsClasses> getGroups(@PathVariable String idClassroom) {
        return iStudentGroupsClassRepo.findAllByIdClassroom(idClassroom);
    }

}
