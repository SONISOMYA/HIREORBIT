package com.hireorbit.hire.orbit.Scheduler;

import com.hireorbit.hire.orbit.entity.JobApplication;
import com.hireorbit.hire.orbit.repository.JobApplicationRepository;
import com.hireorbit.hire.orbit.service.EmailSenderService;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Component
@RequiredArgsConstructor
public class ReminderScheduler {

    private final JobApplicationRepository jobRepo;
    private final EmailSenderService emailService;

    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM yyyy");

    /**
     * ✅ Daily Reminder — only for jobs WITH deadlines.
     *    Sent daily at 8:00 AM until and including the deadline date.
     */
    @Scheduled(cron = "0 0 8 * * *")
    public void sendDailyReminders() {
        List<JobApplication> allJobs = jobRepo.findAllWithUser();

        for (JobApplication job : allJobs) {
            if (job.getDeadline() == null) continue;
            if (job.getUser() == null || job.getUser().getEmail() == null) continue;

            LocalDate today = LocalDate.now();
            if (!today.isAfter(job.getDeadline())) { // ✅ today <= deadline
                emailService.sendEmail(
                        job.getUser().getEmail(),
                        " Reminder: Job Application Pending",
                        "The deadline for the job at <b>" + job.getCompany() + "</b> " +
                                "for the profile of <b>" + job.getTitle() + "</b> is on <b>" +
                                job.getDeadline().format(formatter) + "</b>. Don't miss it!"
                );
            }
        }
    }

    /**
     * ✅ Final Reminder — sent at 6-hour intervals if deadline is today and within 6 hours.
     */
    @Scheduled(cron = "0 0 */6 * * *")
    public void sendLastDayReminders() {
        List<JobApplication> allJobs = jobRepo.findAllWithUser();

        for (JobApplication job : allJobs) {
            if (job.getDeadline() == null) continue;
            if (job.getUser() == null || job.getUser().getEmail() == null) continue;

            LocalDateTime deadlineDateTime = job.getDeadline().atTime(LocalTime.of(23, 59));
            LocalDateTime now = LocalDateTime.now();

            long hoursLeft = java.time.Duration.between(now, deadlineDateTime).toHours();

            if (hoursLeft <= 6 && hoursLeft > 0) {
                emailService.sendEmail(
                        job.getUser().getEmail(),
                        " Final Reminder: Deadline Today!",
                        "The job at <b>" + job.getCompany() + "</b> " +
                                "for the profile of <b>" + job.getTitle() + "</b> " +
                                "has a deadline today (<b>" + job.getDeadline().format(formatter) + "</b>). Please take final action ASAP!"
                );
            }
        }
    }
}