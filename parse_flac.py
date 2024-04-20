from mutagen.flac import FLAC

# Load your FLAC file
audio = FLAC("/path_to_your_flac_here")

# Print metadata
print("Metadata for the FLAC file:")
for tag in audio.tags:
    print(f"{tag}: {audio.tags[tag]}")

# Print other properties
print("\nAudio Properties:")
print(f"Sample rate: {audio.info.sample_rate} Hz")
print(f"Channels: {audio.info.channels}")
print(f"Bits per sample: {audio.info.bits_per_sample}")
print(f"Duration: {audio.info.length} seconds")