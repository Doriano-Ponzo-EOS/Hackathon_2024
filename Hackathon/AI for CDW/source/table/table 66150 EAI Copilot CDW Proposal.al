
table 66150 "EAI Copilot CDW Proposal"
{
    TableType = Temporary;

    fields
    {

        field(1; Select; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Select';
        }

        field(10; "Journal Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
            NotBlank = true;
            TableRelation = "EOS041 CDW Journal Batch".Name;
        }

        field(20; "Line No."; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Line No.';
        }


        field(26; "Type"; Enum "Sales Line Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }

        field(25; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }

        field(30; "Source Document Type"; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Source Document Type';
        }

        field(31; "Source Document Subtype"; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Source Document Subtype';
        }

        field(32; "Source Document No."; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Source Document No.';
        }

        field(33; "Source Document Line No."; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Source Document Line No.';
        }

        field(35; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }

        field(36; "Description 2"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description 2';
        }

        field(40; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }

        field(41; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }

        field(45; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }

        field(46; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }

        field(50; "Reason Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason Code';
            TableRelation = "Reason Code".Code;
        }

        field(60; "Cost Posting Type"; Enum "EOS041 CDW Cost Posting Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Amount Posting Type';
        }

        field(90; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }

        field(91; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }

        field(92; "Invoiced Quantity"; Decimal)
        {
            Caption = 'Invoiced Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }

        field(93; "Invoiced Quantity (Base)"; Decimal)
        {
            Caption = 'Invoiced Quantity (Base)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }

        field(100; "Qty. To Close"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. to Close';
            DecimalPlaces = 0 : 5;

        }

        field(101; "Qty. To Close (Base)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. to Close (base)';
            DecimalPlaces = 0 : 2;
        }


        field(102; "Qty. per Unit of Measure"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. per Unit of Measure';
        }

        field(103; "Unit of Measure Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;
        }

        field(110; "Sell-To/Buy-From No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-To/Buy-From No.';
        }

        field(111; "Sell-To/Buy-From Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-To/Buy-From Name';
        }

        field(200; Handler; Enum "EOS041 Document Type")
        {
            DataClassification = SystemMetadata;
            Caption = 'Handler', Locked = true;
        }

        field(201; "Sign Factor"; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Sign Factor', Locked = true;
        }

        field(202; "CWS No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CWS No.';
        }
    }

    keys
    {
        key(PK; "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }
}