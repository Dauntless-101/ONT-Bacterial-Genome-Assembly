# Frequently Asked Questions

### Q: Do I need to trim adapters?
By default, **no**. Modern Dorado and Guppy basecalling remove adapters automatically. If your reads still contain adapters, set `trimming.enabled: true` in `config.yaml`.

### Q: Which Medaka model should I use?
The pipeline tries to detect the correct model from your reads. If that fails, you can manually set it in `config.yaml`. Run `medaka tools list_models` inside the environment to see all available models.

### Q: How do I increase the memory or threads?
Edit `config.yaml`:

```yaml
threads: 32
