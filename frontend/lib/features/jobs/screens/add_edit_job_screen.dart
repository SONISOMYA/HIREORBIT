import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hireorbit/features/jobs/models/job_application.dart';
import 'package:hireorbit/providers/job_provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
  late String _status;
  DateTime? _appliedDate;
  DateTime? _deadline;
  String _notes = '';

  final List<String> _statusOptions = [
    'Not Applied',
    'Applied',
    'In Progress',
    'Interview Scheduled',
    'Interviewed',
    'Offer Received',
    'Accepted',
    'Rejected',
    'On Hold',
    'Withdrawn'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingJob != null) {
      _title = widget.existingJob!.title;
      _company = widget.existingJob!.company;
      _status = widget.existingJob!.status;
      _appliedDate = widget.existingJob!.appliedDate;
      _deadline = widget.existingJob!.deadline;
      _notes = widget.existingJob!.notes ?? '';
    } else {
      _title = '';
      _company = '';
      _status = _statusOptions.first;
      _notes = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingJob == null ? 'Add Application' : 'Edit Application',
          style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  label: 'Title',
                  initialValue: _title,
                  onSaved: (val) => _title = val ?? '',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Company',
                  initialValue: _company,
                  onSaved: (val) => _company = val ?? '',
                ),
                const SizedBox(height: 16),
                _buildStatusDropdown(),
                const SizedBox(height: 16),
                _buildDatePicker(
                  label: 'Applied Date',
                  selected: _appliedDate,
                  onPicked: (date) => setState(() => _appliedDate = date),
                ),
                const SizedBox(height: 16),
                _buildDatePicker(
                  label: 'Deadline',
                  selected: _deadline,
                  onPicked: (date) => setState(() => _deadline = date),
                ),
                const SizedBox(height: 16),
                _buildNotesField(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      print('Pressed submit');
                      if (_formKey.currentState!.validate()) {
                        print('Form is valid');
                        _formKey.currentState!.save();

                        print('Title: $_title');
                        print('Company: $_company');
                        print('Status: $_status');

                        final newJob = JobApplication(
                          id: widget.existingJob?.id,
                          title: _title,
                          company: _company,
                          status: _status,
                          appliedDate: _appliedDate,
                          deadline: _deadline,
                          notes: _notes.isEmpty ? null : _notes,
                        );

                        try {
                          if (widget.existingJob == null) {
                            await jobProvider.addJob(newJob);
                            print('Job added successfully');
                          } else {
                            await jobProvider.updateJob(newJob);
                            print('Job updated successfully');
                          }

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          print('Error adding job: $e');
                        }
                      } else {
                        print('Form is invalid');
                      }
                    },
                    child: Text(
                      widget.existingJob == null
                          ? 'Add Application'
                          : 'Update Application',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
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
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Required' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      initialValue: _notes,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: 'Notes (Optional)',
      ),
      onSaved: (val) => _notes = val ?? '',
    );
  }

  Widget _buildStatusDropdown() {
    final safeValue =
        _statusOptions.contains(_status) ? _status : _statusOptions.first;

    return DropdownButtonFormField<String>(
      value: safeValue,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
      decoration: InputDecoration(
        labelText: 'Status',
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: Colors.white,
      style: GoogleFonts.nunito(
        fontSize: 16,
        color: Colors.black87,
      ),
      items: _statusOptions
          .map(
            (status) => DropdownMenuItem(
              value: status,
              child: Text(
                status,
                style: GoogleFonts.nunito(fontSize: 16),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) setState(() => _status = value);
      },
      onSaved: (value) {
        if (value != null) _status = value;
      },
    );
  }

  Widget _buildDatePicker({
    required String label,
    DateTime? selected,
    required void Function(DateTime) onPicked,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            selected == null
                ? '$label: Not set'
                : '$label: ${selected.toLocal().toIso8601String().split('T').first}',
            style: GoogleFonts.nunito(),
          ),
        ),
        TextButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selected ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) onPicked(picked);
          },
          child: const Text('Pick Date'),
        ),
      ],
    );
  }
}
