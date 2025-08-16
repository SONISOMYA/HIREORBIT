import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/glass_container.dart';
import '../../jobs/models/job_application.dart';
import '../../../providers/job_provider.dart';

class AddEditJobScreen extends StatefulWidget {
  final JobApplication? existingJob;

  const AddEditJobScreen({super.key, this.existingJob});

  @override
  State<AddEditJobScreen> createState() => _AddEditJobScreenState();
}

class _AddEditJobScreenState extends State<AddEditJobScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _company;
  late String _statusDisplay;
  DateTime? _deadline;
  String _notes = '';

  final Map<String, String> _statusMap = {
    'Not Applied': 'NOT_APPLIED',
    'Applied': 'APPLIED',
    'In Progress': 'IN_PROGRESS',
    'Interview Scheduled': 'INTERVIEW_SCHEDULED',
    'Interviewed': 'INTERVIEWED',
    'Offer Received': 'OFFER_RECEIVED',
    'Accepted': 'ACCEPTED',
    'Rejected': 'REJECTED',
    'On Hold': 'ON_HOLD',
    'Withdrawn': 'WITHDRAWN',
  };

  String _getDisplayStatus(String backendStatus) {
    return _statusMap.entries
        .firstWhere((e) => e.value == backendStatus,
            orElse: () => const MapEntry('Not Applied', 'NOT_APPLIED'))
        .key;
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingJob != null) {
      _title = widget.existingJob!.title;
      _company = widget.existingJob!.company;
      _statusDisplay = _getDisplayStatus(widget.existingJob!.status);
      _deadline = widget.existingJob!.deadline;
      _notes = widget.existingJob!.notes ?? '';
    } else {
      _title = '';
      _company = '';
      _statusDisplay = _statusMap.keys.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.existingJob == null ? 'Add Application' : 'Edit Application',
          style: AppTextStyles.h2,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      label: 'Job Title',
                      initialValue: _title,
                      onSaved: (val) => _title = val ?? '',
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'Company Name',
                      initialValue: _company,
                      onSaved: (val) => _company = val ?? '',
                    ),
                    const SizedBox(height: 20),
                    _buildStatusDropdown(),
                    const SizedBox(height: 20),

                    // ✅ Show deadline only if status is NOT_APPLIED
                    if (_statusMap[_statusDisplay] == 'NOT_APPLIED')
                      _buildDeadlinePicker(),

                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'Notes',
                      initialValue: _notes,
                      maxLines: 4,
                      onSaved: (val) => _notes = val ?? '',
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final newJob = JobApplication(
                              id: widget.existingJob?.id,
                              title: _title,
                              company: _company,
                              status: _statusMap[_statusDisplay]!,
                              deadline: _deadline,
                              notes: _notes.isEmpty ? null : _notes,
                            );

                            try {
                              if (widget.existingJob == null) {
                                await jobProvider.addJob(newJob);
                              } else {
                                await jobProvider.updateJob(newJob);
                              }

                              if (mounted) Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          widget.existingJob == null
                              ? 'Add Application'
                              : 'Update Application',
                          style: AppTextStyles.button
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    int maxLines = 1,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.body.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Required' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildStatusDropdown() {
    return GlassContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          value: _statusDisplay,
          hint: Text(
            'Select Status',
            style: AppTextStyles.body.copyWith(color: Colors.black87),
          ),
          items: _statusMap.keys.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(
                status,
                style: AppTextStyles.body.copyWith(color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _statusDisplay = value;

                // ✅ Clear deadline when not "Not Applied"
                if (_statusMap[value] != 'NOT_APPLIED') {
                  _deadline = null;
                }
              });
            }
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }

  Widget _buildDeadlinePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_deadline != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Deadline: ${_deadline!.toLocal().toIso8601String().split('T').first}',
              style: AppTextStyles.body.copyWith(fontSize: 16),
            ),
          ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.calendar_today, size: 18),
          label: const Text('Pick Date'),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _deadline ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() => _deadline = picked);
            }
          },
        )
      ],
    );
  }
}
