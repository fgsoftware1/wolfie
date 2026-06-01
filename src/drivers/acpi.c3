module wolfie::drivers;

import wolfie::utils;
import wolfie::boot;

struct RSDPDesc @packed
{
	char[8] signature;
	char checksum;
	char[6] oem_id;
	char revision;
	uint rsdt_addr;
}

struct XSDPDesc @packed
{
	// Same structure as RSDP
	char[8] signature;
	char checksum;
	char[6] oem_id;
	char revision;
	uint rsdt_addr; // deprecated on XSDP

	// The new stuff
	uint length;
	ulong xsdp_addr;
	char checksum_ex;
	char[3] reserved;
}

struct SDTHeader @packed
{
	char[4] signature;
	uint length;
	char revision;
	char checksum;
	char[6] oem_id;
	char[8] oem_table_id;
	uint oem_revision;
	uint creator_id;
	uint creator_revision;
}

struct RSDTDesc @packed
{
	SDTHeader header;
	uint[*] entries;
}

fn uint rsdt_entry_count(RSDTDesc* rsdt)
{
    return (rsdt.header.length - SDTHeader::size) / uint::size;
}

fn void acpi_init(uint mbi)
{
	utils::klog("[ACPI] Initializing...");
	boot::MultibootTag* tag = boot::mb2_find_tag((boot::MultibootHeader*)mbi, boot::TagType.ACPI_NEW_RSDP);
	if (tag == null)
	{
		tag = boot::mb2_find_tag((boot::MultibootHeader*)mbi, boot::TagType.ACPI_OLD_RSDP);
	}

	if (tag == null)
	{
		utils::klog("[ACPI] no RSDP tag\n");
		return;
	}
}

fn char verify_rsdt_checksum(SDTHeader* header)
{
	char sum;

	for (uint i = 0; i < header.length; i++)
	{
		sum += ((char*)header)[i];
	}

	return (char)(sum == 0);
}
