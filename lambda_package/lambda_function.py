import json

def lambda_handler(event, context):
    task_id = event.get('taskId')
    if not task_id:
        return {
            'statusCode': 400,
            'body': json.dumps('taskId is required')
        }
    
    # Process the taskId as needed
    # ...

    return {
        'statusCode': 200,
        'body': json.dumps(f'Task ID {task_id} processed successfully')
    }