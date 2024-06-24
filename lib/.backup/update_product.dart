// this is the EXPIRATION DATE for the update product

/*

  DateTime? _expirationDate;

    _expirationDate = DateTime.parse(productMap["expiration_date"]);

    Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _expirationDate) {
      setState(() {
        _expirationDate = picked;
      });
    }
  }

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Expiration Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onTap: () => _selectDate(context),
                            controller: TextEditingController(
                              text: _expirationDate == null
                                  ? ''
                                  : '${_expirationDate!.toLocal()}'
                                      .split(' ')[0],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ],
                    ),






*/