package pe.isil.app.controllers.evaluation;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.isil.app.domain.models.Evaluation;
import pe.isil.app.domain.models.EvaluationSend;
import pe.isil.app.domain.models.User;
import pe.isil.app.domain.repos.IEvaluationRepo;
import pe.isil.app.domain.repos.IEvaluationSendRepo;

import java.util.List;

@RestController
@RequestMapping("/user/evaluations")
@RequiredArgsConstructor
public class EvaluationController {

  private final IEvaluationRepo iEvaluationRepo;
  private final IEvaluationSendRepo iEvaluationSendRepo;

  @PostMapping
  public Evaluation addEvaluation(@RequestBody Evaluation evaluation) {
    return iEvaluationRepo.save(evaluation);
  }

  @PutMapping("/{idEvaluation}")
  public Evaluation updateEvaluation(
      @RequestBody Evaluation evaluation,
      @PathVariable Integer idEvaluation
  ) {

    evaluation.setIdEvaluation(idEvaluation);
    return iEvaluationRepo.save(evaluation);
  }

  @GetMapping("/{idClassroom}")
  public List<Evaluation> getEvaluationsOfClassroom(@PathVariable String idClassroom) {
    return iEvaluationRepo.findAllByIdClassroom(idClassroom);
  }

  @PostMapping("/upload/{idEvaluation}")
  public EvaluationSend uploadMyEvaluation(
      @RequestBody EvaluationSend evaluationSend,
      @PathVariable Integer idEvaluation
  ) {
    var user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

    evaluationSend.setUserSend(user.getIdUser());
    evaluationSend.setIdEvaluation(idEvaluation);

    return iEvaluationSendRepo.save(evaluationSend);
  }

  @PutMapping("/upload/{idSend}")
  public EvaluationSend updateMyEvaluation(
      @RequestBody EvaluationSend evaluationSend,
      @PathVariable Integer idSend
  ) {
    var user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    var evaluationToUpdate = iEvaluationSendRepo.findById(idSend).orElse(null);

    evaluationSend.setIdSend(idSend);
    evaluationSend.setUserUpdate(user.getIdUser());
    evaluationSend.setUserSend(evaluationToUpdate.getUserSend());
    evaluationSend.setSendDate(evaluationToUpdate.getSendDate());
    evaluationSend.setIdEvaluation(evaluationToUpdate.getIdEvaluation());
    return iEvaluationSendRepo.save(evaluationSend);
  }
}
