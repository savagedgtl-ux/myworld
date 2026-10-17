import OpenAI from 'openai';
import { zodTextFormat } from 'openai/helpers/zod';
import { defineSecret } from 'firebase-functions/params';
import { HttpsError } from 'firebase-functions/v2/https';
import * as logger from 'firebase-functions/logger';
import type { z } from 'zod';

export const OPENAI_API_KEY = defineSecret('OPENAI_API_KEY');

export const MODELS = {
  extraction: process.env.OPENAI_MODEL_EXTRACTION || 'gpt-5-mini',
  ask: process.env.OPENAI_MODEL_ASK || 'gpt-5-mini',
  classify: process.env.OPENAI_MODEL_CLASSIFY || 'gpt-5-nano',
};

let client: OpenAI | null = null;
function openai(): OpenAI {
  if (!client) {
    const key = OPENAI_API_KEY.value();
    if (!key) throw new HttpsError('unavailable', 'ai_not_configured');
    client = new OpenAI({ apiKey: key });
  }
  return client;
}

export type InputPart =
  | { type: 'input_text'; text: string }
  | { type: 'input_image'; image_url: string; detail: 'low' | 'high' | 'auto' }
  | { type: 'input_file'; filename: string; file_data: string };

export interface StructuredResult<T> {
  data: T;
  inputTokens: number;
  outputTokens: number;
  model: string;
}

/**
 * Single entry point for all model calls: strict JSON schema output, bounded
 * output tokens, no tools (the model cannot take actions), and no logging of
 * document content.
 */
export async function structuredCall<S extends z.ZodTypeAny>(args: {
  model: string;
  system: string;
  user: InputPart[];
  schema: S;
  schemaName: string;
  maxOutputTokens: number;
}): Promise<StructuredResult<z.infer<S>>> {
  try {
    const res = await openai().responses.parse({
      model: args.model,
      instructions: args.system,
      input: [{ role: 'user', content: args.user }],
      text: { format: zodTextFormat(args.schema, args.schemaName) },
      max_output_tokens: args.maxOutputTokens,
      reasoning: { effort: 'low' },
      store: false,
    });
    const parsed = (res as any).output_parsed;
    if (parsed == null) throw new HttpsError('internal', 'ai_invalid_output');
    return {
      data: parsed,
      inputTokens: res.usage?.input_tokens ?? 0,
      outputTokens: res.usage?.output_tokens ?? 0,
      model: args.model,
    };
  } catch (e: any) {
    if (e instanceof HttpsError) throw e;
    logger.error('openai_call_failed', { status: e?.status, code: e?.code, type: e?.type });
    if (e?.status === 429) throw new HttpsError('resource-exhausted', 'ai_provider_busy');
    throw new HttpsError('unavailable', 'ai_failed');
  }
}
