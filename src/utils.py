from sklearn.pipeline import Pipeline
from joblib import dump

def update_model(model: Pipeline) -> None:
    dump(model, 'model/model.pkl')

def save_simple_metrics_report(train_score: float, test_score: float, validation_score: float, model: Pipeline) -> None:
    with open('report.txt','w') as report_file:
        report_file.write('# Model Pipeline Description' + '\n')
        for key, value in model.named_steps.items():
            report_file.write(f'### {key}: {value.__repr__()}'+'\n')
        report_file.write(f'## Train Score: {train_score}'+ '\n')
        report_file.write(f'## Test Score: {test_score}'+ '\n')
        report_file.write(f'## Validation Score: {validation_score}')