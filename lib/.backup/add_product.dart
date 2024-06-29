// this is a widget for EXPIRATION DATE

/*

  DateTime? _expirationDate;

      _expirationDate = null;


HISTORY : : : 

final List<Map<String, String>> historyLogs = [
    {
      'date': '2024-01-24',
      'name': 'Product A',
      'id': '0963736112',
      'quantity': '5',
      'type': 'decrease'
    },
    {
      'date': '2024-05-24',
      'name': 'Product B',
      'id': '0963736113',
      'quantity': '3',
      'type': 'increase'
    },
    {
      'date': '2024-06-26',
      'name': 'Product C',
      'id': '0963736114',
      'quantity': '2',
      'type': 'increase'
    },
    {
      'date': '2023-12-20',
      'name': 'Product D',
      'id': '0963736115',
      'quantity': '4',
      'type': 'decrease'
    },
  ];



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
                            : '${_expirationDate!.toLocal()}'.split(' ')[0],
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